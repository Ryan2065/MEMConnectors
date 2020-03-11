Function Get-PowerAutomateEnvironment {
    (Invoke-PowerAutomateWebRequest -Path 'environments' -FlowRequest).Value
}