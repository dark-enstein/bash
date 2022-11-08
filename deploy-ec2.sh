name: .ci-cd
on:
    push:
    pull_request:

env:
    ARTIFACTORY_USERNAME: ${{ secrets.ARTIFACTORY_USERNAME }}
    ARTIFACTORY_PASSWORD: ${{ secrets.ARTIFACTORY_PASSWORD }}

jobs:
    test:
        name: run-tests
        runs-on: ubuntu-20.04
        steps:
            - name: checkout
              uses: actions/checkout@v3
            - name: jdk8
              uses: actions/setup-java@v3
              with:
                  java-version: '8'
                  cache: 'maven'
                  distribution: 'adopt'
            - name: test
              run: |
                  ./mvnw test

    publish-to-artifactory:
        name: publish
        needs: [test]
        if: github.event_name == 'push'
        runs-on: ubuntu-20.04
        steps:
            - name: checkout
              uses: actions/checkout@v3
            - name: Use Node.js 8.12.0
              uses: actions/setup-node@v3
              with:
                  node-version: 8.12.0

            - name: Install NPM dependencies
              run: cd src/main/webapp && npm install
            - name: Build Node Jar
              run: cd src/main/webapp && node --max_old_space_size=8192 node_modules/@angular/cli/bin/ng  build --prod --app=retail-app && mv ../resources/static/index-retail.html ../resources/static/index.html
            - name: set up jdk8
              uses: actions/setup-java@v3
              with:
                  java-version: '8'
                  cache: 'maven'
                  distribution: 'adopt'
            - name: build jar
              run: |
                  mvn -B -U clean package -DskipTests
            - name: publish
              run: |
                  #script uses the artifactory username and password by default
                  bash .mvn/publish.sh

    deploy:
        name: deploy to UAT
        if: github.event_name == 'push' && contains(github.ref, 'refs/tags/')
        needs: [test, publish]
        runs-on: ubuntu-latest

        steps:
            - name: Code checkout
              uses: actions/checkout@v2

            - name: Extract Maven project version
              run: |
                  chmod +x .github/
                  chmod +x .github/scripts/version.sh
                  echo ::set-output name=version::$(bash .github/scripts/version.sh; echo ${ARTIFACT_VER})
              id: project

            - name: Show extracted Maven project version
              run: echo ${{ steps.project.outputs.version }}

            - name: Setting up new jar
              run: |
                  echo $VERSION
                  echo "${{ secrets.TEST_SERVER_SSH_KEY }}" > pemfile.pem
                  chmod 400 pemfile.pem
                  #run start up shell-script via ssh
                  ssh -i pemfile.pem -o StrictHostKeyChecking=no ubuntu@${{ secrets.TEST_SERVER_URL }} 'cd crow && /bin/bash lice.sh ${{ secrets.GROUP_ID }} ${{ secrets.ARTIFACT_ID }} ${{ env.VERSION }}'
              env:
                  VERSION: ${{ steps.project.outputs.version }}

            - name: Slack Notification
              uses: rtCamp/action-slack-notify@v2
              env:
                  SLACK_CHANNEL: deployments
                  SLACK_COLOR: ${{ job.status }} # or a specific color like 'good' or '#ff00ff'
                  SLACK_ICON: https://github.com/rtCamp.png?size=48
                  SLACK_MESSAGE: ':rocket:'
                  SLACK_TITLE: Successfully deployed ${{ github.event.repository.name }} ${{ steps.project.outputs.version }} to Test
                  SLACK_USERNAME: Deployment
                  SLACK_WEBHOOK: ${{ secrets.SLACK_WEBHOOK }}
