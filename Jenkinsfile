node {    stage ('checkout') {    checkout([$class: 'SubversionSCM',           additionalCredentials: [],           excludedCommitMessages: '',           excludedRegions: '',           excludedRevprop: '',           excludedUsers: '',           filterChangelog: false,           ignoreDirPropChanges: false,           includedRegions: '',           locations: [[credentialsId: '41a88e06-6142-4f8e-9c1f-994b5047776e',                        depthOption: 'infinity',                        ignoreExternalsOption: true,                        local: '',                        remote: "http://swplvapp457/svn/svnroot/VPAS_WebUI_CashManagement/VPAS_CashManagement/"]],           workspaceUpdater: [$class: 'UpdateUpdater']])    }   //def mvnHome   stage('CodeQuality Check') { // CodeQuality Check using SonarQube                       //mvnHome = tool 'M3'     // bat '''SET var=%cd%     // ECHO %var%'''      dir('VPAS_CashManagement/webClient/vpaswebui') {          def stdout = bat(script: 'npm install', returnStdout: true)          println stdout          def scannerHome = tool 'SonarQube Scanner';                withSonarQubeEnv('SonarQube Server') {           bat "${scannerHome}/bin/sonar-scanner.bat"      }
               // if (isUnix()) {       //  sh "'${mvnHome}/bin/mvn' -Dmaven.test.failure.ignore clean package"    // } else {       // bat(/"${mvnHome}\bin\mvn" sonar:sonar -Dsonar.projectKey=VPAS_UI_CASHMGMT -Dsonar.projectName=VPAS_UI_CASHMGMT -Dsonar.sources=vpaswebui\src -Dsonar.language=ts -Dsonar.ts.tslint.path=C:\VPAS_CashManagement\webClient\vpaswebui\node_modules\tslint\bin\tslint -Dsonar.inclusions=** -Dsonar.exclusions=node_modules\** -Dsonar.ts.tslint.configPath=vpaswebui\tslint.json -X/)    // }    //  }        }   }}   // No need to occupy a node
stage("CodeQuality Gate Check"){
  timeout(time: 1, unit: 'HOURS') { // Just in case something goes wrong, pipeline will be killed after a timeout
    def qg = waitForQualityGate() // Reuse taskId previously collected by withSonarQubeEnv
    if (qg.status != 'OK') {
      error "Pipeline aborted due to quality gate failure: ${qg.status}"
    }
  }
}stage('UnitTesting approval'){    input "Execute UnitTestcases?"}node {   stage('UnitTesting') {      // Run the Unit Test Cases      dir('VPAS_CashManagement/webClient/vpaswebui') {                    bat '''set PATH=%PATH%;%AppData%\\npm            ng test --reporters junit,dots || EXIT /B 0'''        //script{        // set PATH=%PATH%;%AppData%\npm        // ng test --reporters junit,dots || EXIT /B 0          //def stdout = bat(script: 'npm install', returnStdout: true)        //}      }
   }  stage("UnitTest reports Publishing and Threshold Checking"){   step([    $class: 'XUnitBuilder', testTimeMargin: '3000',// thresholdMode: 1,    thresholds: [        [$class: 'FailedThreshold', failureNewThreshold: '', failureThreshold: '', unstableNewThreshold: '', unstableThreshold: ''],        [$class: 'SkippedThreshold', failureNewThreshold: '', failureThreshold: '', unstableNewThreshold: '', unstableThreshold: '']    ],    tools: [[        $class: 'UnitTestJunitHudsonTestType',        deleteOutputFiles: false,        failIfNotNew: false,        pattern: 'VPAS_CashManagement/webClient/vpaswebui/karma_junit/*.xml',        skipNoTestFiles: false,        stopProcessingIfError: false    ]]])}
   stage('Results') {      //junit '**/target/surefire-reports/TEST-*.xml'      //archive 'target/*.jar'   }}