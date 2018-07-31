<master class="h-100">
    <div class="container-fluid">
        <p>Your Id: {clientId}</p>
        <p>Software Version: {softwareVersion}</p>
        
        <p>Is Mobile: {isMobile}</p>
        <p>Is Andriod: {isAndriod}</p>
        <p>Is iOS: {isAppleiOS}</p>

        <p>Browser (Name): {browserName}</p>
        <p>Browser version: {browserVersion}</p>
        <p>Browser major version: {browserMajorVersion}</p>

        <p>Browser engine (Name): {engineName}</p>
        <p>Browser engine version: {engineVersion}</p>

        <p>OS (Name): {osName}</p>
        <p>OS version: {osVersion}</p>

        <p>CPU: {CPU}</p>

        <p>Current Resolution: {currentResolution}</p>

        <p>Enable local storage: {enableLocalStorage}</p>
        <p>Enable cookies: {enableCookies}</p>
    </div>
    <style>
    </style>
    <script>
        let client = new ClientJS();
        this.clientId = client.getFingerprint();;
        this.softwareVersion = client.getSoftwareVersion();
        this.isMobile = client.isMobile() ? "Yes" : "No";
        this.isAndriod = client.isMobileAndroid() ? "Yes" : "No";
        this.isAppleiOS = client.isMobileAndroid() ? "Yes" : "No";
        //this.userAgent = client.getBrowserData().ua;
        this.userAgent = client.getUserAgentLowerCase();

        this.browserName = client.getBrowser(); // Get Browser.
        this.browserVersion = client.getBrowserVersion(); // Get Browser Version.
        this.browserMajorVersion = client.getBrowserMajorVersion(); // Get Browser's Major Version

        this.engineName = client.getEngine(); // Get Engine
        this.engineVersion = client.getEngineVersion(); // Get Engine Version

        this.osName = client.getOS(); // Get OS Version
        this.osVersion = client.getOSVersion(); // Get OS Version

        this.CPU = client.getCPU(); // Get CPU Architecture

        this.currentResolution = client.getCurrentResolution(); // Get Current Resolution

        this.enableLocalStorage = client.isLocalStorage(); // Check For Local Storage
        this.enableCookies = client.isCookie(); // Check For Local Storage
    </script>
</master>