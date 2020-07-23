import QtQuick 2.9
import QtQuick.Controls 2.14
import QtQuick.Dialogs 1.2
import QtQml.Models 2.14
import Qt.labs.platform 1.1 as Platform

import org.scintilla.sciteqt 1.0

ApplicationWindow {
    id: applicationWindow
    width: 800
    height: 600
    visible: true

    property string urlPrefix: "file://"

    onClosing: {
        sciteQt.CmdExit()
        close.accepted = false
    }

    Component.onCompleted: {
        console.log("ON Completed")
        sciteQt.setScintilla(quickScintillaEditor.scintilla)
        sciteQt.setOutput(quickScintillaOutput.scintilla)
        sciteQt.setMainWindow(applicationWindow)
        sciteQt.setApplicationData(applicationData)
        console.log("ON Completed done")
    }

    function max(v1, v2) {
        return v1 < v2 ? v2 : v1;
    }

    function startFileDialog(sDirectory, sFilter, bAsOpenDialog) {
        //fileDialog.selectExisting = bAsOpenDialog
        fileDialog.openMode = bAsOpenDialog
        fileDialog.folder = sDirectory
        //fileDialog.nameFilters = sFilter // as list of strings...
        fileDialog.open()
    }

    function buildValidUrl(path) {
        // ignore call, if we already have a file:// url
        path = path.toString()
        if( path.startsWith(urlPrefix) )
        {
            return path;
        }
        // ignore call, if we already have a content:// url (android storage framework)
        if( path.startsWith("content://") )
        {
            return path;
        }

        var sAdd = path.startsWith("/") ? "" : "/"
        var sUrl = urlPrefix + sAdd + path
        return sUrl
    }

    function writeCurrentDoc(url) {
        console.log("write current... "+url)
        sciteQt.saveCurrentAs(url)
    }

    function readCurrentDoc(url) {
        // then read new document
        console.log("read current doc "+url)
        var urlFileName = buildValidUrl(url)
        lblFileName.text = urlFileName
        sciteQt.doOpen(url)
        //quickScintillaEditor.text = applicationData.readFileContent(urlFileName)
    }

    function showInfoDialog(infoText,style) {
        //mbsOK = 0,
        //mbsYesNo = 4,
        //mbsYesNoCancel = 3,
        //mbsIconQuestion = 0x20,
        //mbsIconWarning = 0x30
        if((style & 7) === 4)
        {
            infoDialog.standardButtons = StandardButton.Yes | StandardButton.No
        }
        if((style & 7) === 3)
        {
            infoDialog.standardButtons = StandardButton.Yes | StandardButton.No | StandardButton.Cancel
        }

        infoDialog.text = infoText
        infoDialog.open()
    }

    function processMenuItem(menuText, menuItem) {
        var s = sciteQt.getLocalisedText(menuText)
        if( menuItem !== null && menuItem.shortcut !== undefined)
        {
            s += "\t" + menuItem.shortcut
        }
        return s
    }

    menuBar: MenuBar {
        id: menuBar

        Menu {
            id: fileMenu
            title: processMenuItem(qsTr("&File"),null)

            Action {
                id: actionNew
                text: processMenuItem(qsTr("&New"), actionNew)
                //icon.source: "share.svg"
                shortcut: "Ctrl+N"
                onTriggered: sciteQt.CmdNew()
            }
            Action {
                id: actionOpen
                text: processMenuItem(qsTr("&Open..."), actionOpen)
                //icon.source: "share.svg"
                shortcut: "Ctrl+O"
                onTriggered: sciteQt.CmdOpen()
            }
            Action {
                id: actionRevert
                text: processMenuItem(qsTr("&Revert"), actionRevert)
                shortcut: "Ctrl+W"
                onTriggered: sciteQt.CmdRevert()
            }
            Action {
                id: actionClose
                text: processMenuItem(qsTr("&Close"), actionClose)
                shortcut: "Ctrl+W"
                onTriggered: sciteQt.CmdClose()
            }
            Action {
                id: actionSave
                text: processMenuItem(qsTr("&Save"), actionSave)
                shortcut: "Ctrl+S"
                onTriggered: sciteQt.CmdSave()
            }
            Action {
                id: actionSaveAs
                text: processMenuItem(qsTr("Save &As..."), actionSaveAs)
                onTriggered: sciteQt.CmdSaveAs()
            }
            Action {
                id: actionCopyPath
                text: processMenuItem(qsTr("Copy Pat&h"), actionCopyPath)
                onTriggered: sciteQt.CmdCopyPath()
            }
            MenuSeparator {}
            Action {
                id: actionExit
                text: processMenuItem(qsTr("E&xit"), actionExit)
                onTriggered: sciteQt.CmdExit()
            }
        }

        Menu {
            id: editMenu
            title: processMenuItem(qsTr("Edit"),null)

            Action {
                id: actionUndo
                text: processMenuItem(qsTr("&Undo"), actionUndo)
                shortcut: "Ctrl+Z"
                onTriggered: sciteQt.CmdUndo()
            }
            Action {
                id: actionRedo
                text: processMenuItem(qsTr("&Redo"), actionRedo)
                shortcut: "Ctrl+Y"
                onTriggered: sciteQt.CmdRedo()
            }
            MenuSeparator {}
            Action {
                id: actionCut
                text: processMenuItem(qsTr("Cu&t"), actionCut)
                shortcut: "Ctrl+X"
                onTriggered: sciteQt.CmdCut()
            }
            Action {
                id: actionCopy
                text: processMenuItem(qsTr("&Copy"), actionCopy)
                shortcut: "Ctrl+C"
                onTriggered: sciteQt.CmdCopy()
            }
            Action {
                id: actionPaste
                text: processMenuItem(qsTr("&Paste"), actionPaste)
                shortcut: "Ctrl+V"
                onTriggered: sciteQt.CmdPaste()
            }
        }

        Menu {
            id: searchMenu
            title: processMenuItem(qsTr("Search"),null)

            Action {
                id: actionFind
                text: processMenuItem(qsTr("&Find..."), actionFind)
                shortcut: "Ctrl+F"
                onTriggered: sciteQt.CmdFind()
            }
            Action {
                id: actionFindNext
                text: processMenuItem(qsTr("Find &Next"), actionFindNext)
                shortcut: "F3"
                onTriggered: sciteQt.CmdFindNext()
            }
            Action {
                id: actionFindPrevious
                text: processMenuItem(qsTr("Find &Next"), actionFindPrevious)
                shortcut: "Shift+F3"
                onTriggered: sciteQt.CmdFindPrevious()
            }
        }

        Menu {
            id: viewMenu
            title: processMenuItem(qsTr("&View"),null)

            Action {
                id: actionShowToolBar
                text: processMenuItem(qsTr("&Tool Bar"), actionShowToolBar)
                checkable: true
                checked: scitQt.showToolBar
                onTriggered: sciteQt.CmdShowToolBar()
            }
            Action {
                id: actionShowStatusBar
                text: processMenuItem(qsTr("&Status Bar"), actionShowStatusBar)
                checkable: true
                checked: scitQt.showStatusBar //applicationData !== null ? applicationData.showStatusBar : false
                onTriggered: sciteQt.CmdShowStatusBar()
            }
            Action {
                text: qsTr("Line &Numbers")
                checkable: true
                checked: false
                onTriggered: sciteQt.CmdLineNumbers()
            }
        }


        Menu {
            id: toolsMenu
            title: processMenuItem(qsTr("Tools"),null)
        }

        Menu {
            id: optionsMenu
            title: processMenuItem(qsTr("Options"),null)

            Action {
                id: actionAlwaysOnTop
                text: processMenuItem(qsTr("&Always On Top"),actionAlwaysOnTop)
                checkable: true
                checked: false
                onTriggered: sciteQt.CmdAlwaysOnTop()
            }
            Action {
                id: actionUseMonospacedFont
                text: processMenuItem(qsTr("Use &Monospaced Font"),actionUseMonospacedFont)
                checkable: true
                checked: false
                onTriggered: sciteQt.CmdUseMonospacedFont()
            }
        }

        Menu {
            id: languageMenu
            title: processMenuItem(qsTr("Language"),null)

            Instantiator {
                id: currentLanguagesItems
                model: languagesModel
                delegate: MenuItem {
                    //checkable: true
                    //checked: model !== null ? model.checkState : false
                    text: model.display // index is also available
                    onTriggered: sciteQt.CmdSelectLanguage(index)
                }

                onObjectAdded: languageMenu.insertItem(index, object)
                onObjectRemoved: languageMenu.removeItem(object)
            }
        }

        Menu {
            id: buffersMenu
            title: processMenuItem(qsTr("&Buffers"),null)

            Action {
                id: actionBuffersPrevious
                text: processMenuItem(qsTr("&Previous"), actionBuffersPrevious)
                shortcut: "Shift+F6"
                onTriggered: sciteQt.CmdBuffersPrevious()
            }
            Action {
                id: actionBuffersNext
                text: processMenuItem(qsTr("&Next"), actionBuffersNext)
                shortcut: "F6"
                onTriggered: sciteQt.CmdBuffersNext()
            }
            Action {
                id: actionBuffersCloseAll
                text: processMenuItem(qsTr("&Close All"), actionBuffersCloseAll)
                onTriggered: sciteQt.CmdBuffersCloseAll()
            }
            Action {
                id: actionBuffersSaveAll
                text: processMenuItem(qsTr("&Save All"), actionBuffersSaveAll)
                onTriggered: sciteQt.CmdBuffersSaveAll()
            }

            MenuSeparator {}

            Instantiator {
                id: currentBufferItems
                model: buffersModel
                delegate: MenuItem {
                    checkable: true
                    checked: model.checkState ? Qt.Checked : Qt.Unchecked
                    text: model.display // index is also available
                    onTriggered: sciteQt.CmdSelectBuffer(index)
                }

                onObjectAdded: buffersMenu.insertItem(index+5, object)
                onObjectRemoved: buffersMenu.removeItem(object)
            }
        }

        Menu {
            id: helpMenu
            title: processMenuItem(qsTr("Help"),null)

            Action {
                id: actionHelp
                shortcut: "F1"
                text: processMenuItem(qsTr("&Help"),actionHelp)
                onTriggered: sciteQt.CmdHelp()
            }
            Action {
                id: actionSciteHelp
                text: processMenuItem(qsTr("&SciTE Help"),actionSciteHelp)
                onTriggered: sciteQt.CmdSciteHelp()
            }
            Action {
                id: actionAboutScite
                text: processMenuItem(qsTr("&About SciTE"),actionAboutScite)
                onTriggered: sciteQt.CmdAboutScite()
            }

            MenuSeparator {}

            MenuItem {
                id: actionDebugInfo
                text: processMenuItem(qsTr("Debug info"),actionDebugInfo)
                onTriggered: {
                    //showInfoDialog(quickScintillaEditor.text)
                    ///*for Tests only: */quickScintillaEditor.text = applicationData.readLog()
                    //console.log("dbg: "+myModel+" "+myModel.count)
                    //myModel.append({"display":"blub blub"})
                    //console.log("dbg: "+myModel+" "+myModel.count+" "+myModel.get(0))
                    removeInBuffersModel(0)
                }
            }
/*
            Instantiator {
                id: dynamicTestMenu
                model: buffersModel
                delegate: MenuItem {
                    checkable: true
                    checked: model.checkState ? Qt.Checked : Qt.Unchecked
                    text: model.display
                    onTriggered: console.log(index)
                }

                onObjectAdded: helpMenu.insertItem(index+6, object)
                onObjectRemoved: helpMenu.removeItem(object)
            }
*/

        }
    }

    header: ToolBar {
        contentHeight: readonlyIcon.implicitHeight
        visible: sciteQt.showToolBar

        ToolButton {
            id: readonlyIcon
            //icon.source: "edit.svg"
            text: "Open"
            visible: sciteQt.showToolBar
            //anchors.right: readonlySwitch.left
            //anchors.rightMargin: 1
            onClicked: {
                fileDialog.openMode = true
                fileDialog.open()
            }
        }
    }

    footer:  Text {
        id: statusBarText
        visible: sciteQt.showStatusBar

        text: sciteQt.statusBarText

        MouseArea {
            anchors.fill: parent
            onClicked: sciteQt.onStatusbarClicked()
        }
    }

    Text {
        id: lblFileName
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        //anchors.verticalCenter: btnShowText.verticalCenter
        anchors.leftMargin: 5
        anchors.rightMargin: 5
        anchors.topMargin: 5
        anchors.bottomMargin: 5
        text: "?"
    }

    FileDialog {
        id: fileDialog
        objectName: "fileDialog"
        visible: false
        modality: Qt.WindowModal
        //fileMode: openMode ? FileDialog.OpenFile : FileDialog.SaveFile
        title: openMode ? qsTr("Choose a file") : qsTr("Save as")
        folder: "."

        property bool openMode: true

        selectExisting: openMode ? true : false
        selectMultiple: false
        selectFolder: false

        onAccepted: {
            //console.log("Accepted: " + /*currentFile*/fileUrl+" "+fileDialog.openMode)
            if(!fileDialog.openMode) {
                writeCurrentDoc(fileUrl)
            }
            else {
                //Android: quickScintillaEditor.text = fileUrl
                readCurrentDoc(fileUrl)
            }
            quickScintillaEditor.focus = true
        }
        onRejected: {
            quickScintillaEditor.focus = true
        }
    }

    MessageDialog {
        id: infoDialog
        objectName: "infoDialog"
        visible: false
        title: qsTr("Info")
        //modal: true
        //modality: Qt.WindowModality
        standardButtons: StandardButton.Ok
        /*
        onAccepted: {
            quickScintillaEditor.focus = true
            console.log("accept")
        }
        onRejected: console.log("reject")
        onYes: console.log("yes")
        onNo: console.log("no")
        */
    }

    SplitView {
        id: splitView

        //anchors.fill: parent
        anchors.top: lblFileName.bottom
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.rightMargin: 5
        anchors.leftMargin: 5
        anchors.topMargin: 5
        anchors.bottomMargin: 5

        ScintillaText {
            id: quickScintillaEditor

            SplitView.preferredWidth: 2 * parent.width / 3

            //text: "editor area !"
        }

        ScintillaText {
            id: quickScintillaOutput

            SplitView.preferredWidth: parent.width / 3

            //text: "blub output !"
        }
/*
        ListView {
            id: listView

            model: buffersModel
            delegate: Text {
                      text: "idx=" + index+ " obj=" + model.display
                  }

            SplitView.preferredWidth: parent.width / 2
        }
*/
    }

    ListModel {
        id: myModel

        ListElement {
            display: "item 1"
        }
        ListElement {
            display: "item 2"
        }
    }

    function clearBuffersModel(model) {
        model.clear()
    }
    function writeInBuffersModel(model,index, name, checked) {
        model.set(index, {"display":name, "checkState":checked})
    }
    function removeInBuffersModel(model,index) {
        if(index < model.count) {
            model.remove(index)
        }
    }
    function setCheckStateInBuffersModel(model,index, checked) {
        if(index < model.count) {
            model.setProperty(index,"checkState",checked)
        }
    }

    function handleMenuChecked(menuId, val) {
        switch(menuId) {
            case 450:  //IDM_MONOFONT
                console.log("SET MONSPACED check! "+val)
                actionUseMonospacedFont.checked = val
                break;
            case 411:  //IDM_VIEWSTATUSBAR
                console.log("SET STATUSBar check! "+val)
                actionShowStatusBar.checked = val
                break;
            case 408:  //IDM_VIEWTOOLBAR
                console.log("SET ToolBar check! "+val)
                actionShowToolBar.checked = val
                break;
        }
    }

    ListModel {
        id: buffersModel
        /*
        ListElement {
            display: "hello"
            checkState: true
        }
        */
    }

    ListModel {
        id: languagesModel
        /*
        ListElement {
            display: "hello"
            checkState: true
        }
        */
    }

    SciTEQt {
       id: sciteQt
    }

    Connections {
        target: sciteQt

        onSetMenuChecked: {
            handleMenuChecked(menuID, val)
        }

        onSetInBuffersModel: {
            writeInBuffersModel(buffersModel, index, txt, checked)
        }
        onRemoveInBuffersModel: {
            removeInBuffersModel(buffersModel, index)
        }
        onCheckStateInBuffersModel: {
            setCheckStateInBuffersModel(buffersModel, index, checked)
        }
        onSetInLanguagesModel: {
            writeInBuffersModel(languagesModel, index, txt, checked)
        }
        onRemoveInLanguagesModel: {
            removeInLanguagesModel(languagesModel, index)
        }
        onCheckStateInLanguagesModel: {
            setCheckStateInLanguagesModel(languagesModel, index, checked)
        }
    }
}