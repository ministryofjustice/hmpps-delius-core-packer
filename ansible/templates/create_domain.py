from java.lang import System


def initConfigToScriptRun():
    global startedNewServer
    loadProperties("/u01/software/domain.properties")
    hideDisplay()
    hideDumpStack("true")
    # try connecting to a running server if it is already running ...
    if connected == "false":
        try:
            URL = "t3://" + adminServerListenAddress + ":" + adminServerListenPort
            connect(userName, passWord, URL)
        except WLSTException:
            print 'No server is running at ' + URL + ', the script will start a new server'
    hideDumpStack("false")
    if connected == "false":
        print 'Starting a brand new server at ' + URL + ' with server name ' + adminServerName
        print 'Please see the server log files for startup messages available at ' + domainDir
        # If a config.xml exists in the domainDir, WLST will use that config.xml to bring up the server.
        # If you would like WLST to overwrite this directory, you should specify overWriteRootDir='true' as shown below
        # startServer(adminServerName, domName, URL, userName, passWord,domainDir, overWriteRootDir='true')
        _timeOut = Integer(TimeOut)
        # If you want to specify additional JVM arguments, set them using startServerJvmArgs in the property file or below
        _startServerJvmArgs = startServerJvmArgs
        if (_startServerJvmArgs == "" and (
                System.getProperty("java.vendor").find("Sun") >= 0 or System.getProperty("java.vendor").find(
                "Hewlett") >= 0)):
            _startServerJvmArgs = " -XX:MaxPermSize=128m"
        if overWriteRootDir == 'true':
            startServer(adminServerName, domName, URL, userName, passWord, domainDir, timeout=_timeOut.intValue(),
                        overWriteRootDir='true', block='true', jvmArgs=_startServerJvmArgs)
        else:
            startServer(adminServerName, domName, URL, userName, passWord, domainDir, timeout=_timeOut.intValue(),
                        block='true', jvmArgs=_startServerJvmArgs)
        startedNewServer = 1
        print "Started Server. Trying to connect to the server ... "
        connect(userName, passWord, URL)
        if connected == 'false':
            stopExecution('You need to be connected.')


def startTransaction():
    edit()
    startEdit()


def endTransaction():
    startEdit()
    save()
    activate(block="true")


def endOfScriptRun():
    global startedNewServer
    # Save the changes you have made
    # shutdown the server you have started
    if startedNewServer == 1:
        print 'Shutting down the server that is started... '
        shutdown(force='true', block='true')
    print 'Done executing the script.'


def create_Server(path, beanName):
    cd(path)
    try:
        print "creating mbean of type Server ... "
        theBean = cmo.lookupServer(beanName)
        if theBean == None:
            cmo.createServer(beanName)
    except java.lang.UnsupportedOperationException, usoe:
        pass
    except weblogic.descriptor.BeanAlreadyExistsException, bae:
        pass
    except java.lang.reflect.UndeclaredThrowableException, udt:
        pass


def setAttributes_Domain():
    cd("/")
    print "setting attributes for mbean type Domain"
    set("DomainVersion", "10.3.6.0")
    set("ProductionModeEnabled", "true")
    set("ConfigurationVersion", "10.3.6.0")
    set("AdminServerName", "AdminServer")


def setAttributesFor_AdminServer():
    cd("/Servers/AdminServer")
    print "setting attributes for mbean type Server"
    set("ListenAddress", adminServerListenAddress)

    cd("/Servers/AdminServer/SSL/AdminServer")
    print "setting JSSEEnabled attribute"
    set("JSSEEnabled", "true")


def setAttributes_SSL():
    cd("/Servers/AdminServer/SSL/AdminServer")
    print "setting attributes for mbean type SSL"
    set("Enabled", "true")


def deploy_jsf():
    try:
        deploy("jsf#1.2@1.2.9.0", "/u01/app/oracle/middleware/wlserver_10.3/common/deployable-libraries/jsf-1.2.war",
               "AdminServer,", securityModel="DDOnly", libraryModule="true", block="true")
    except:
        print "Could not deploy application jsf#1.2@1.2.9.0"


try:
    initConfigToScriptRun()
    startTransaction()
    create_Server("/", "AdminServer")
    setAttributesFor_AdminServer()
    setAttributes_Domain()
    setAttributes_SSL()
    endTransaction()
    deploy_jsf()
finally:
    endOfScriptRun()
