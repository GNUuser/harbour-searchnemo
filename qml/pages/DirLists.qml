/*
    SearchNemo - A program for search text in local files
    Copyright (C) 2016 SargoDevel
    Contact: SargoDevel <sargo-devel@go2.pl>

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License version 3.

    This program is distributed WITHOUT ANY WARRANTY.
    See the GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

import QtQuick 2.2
import Sailfish.Silica 1.0
import harbour.searchnemo.Settings 1.0
import "../components"

Page {
    id: dirsPage
    allowedOrientations: Orientation.All

    //profile currently edited
    property string profileName

    //signal used for return parameters
    signal ret
    Component.onDestruction: { dirListModel.writeList(); ret() }
    Component.onCompleted: {dirListModel.readList()}

    Settings { id: settings }

    //dirListModel contains list of white- and blacklisted directories
    //list model: dirname=fullpath, enable=true/false (whitelisted/blacklisted)
    ListModel {
        id: dirListModel

        function readList() {
            dirListModel.clear()
            var list = []
            list=settings.readStringList(profileName+" Whitelist")
            for (var i = 0; i < list.length; i++) {
                dirListModel.append({"dirname": list[i], "enable": true})
            }
            list=settings.readStringList(profileName+" Blacklist")
            for (i = 0; i < list.length; i++) {
                dirListModel.append({"dirname": list[i], "enable": false})
            }
        }

        function writeList() {
            var wlist = []
            var blist = []
            for (var i = 0; i < dirListModel.count; i++) {
                if(dirListModel.get(i).enable) wlist.push(dirListModel.get(i).dirname)
                else blist.push(dirListModel.get(i).dirname)
            }
            settings.remove(profileName+" Whitelist");
            settings.writeStringList(profileName+" Whitelist",wlist)
            settings.remove(profileName+" Blacklist");
            settings.writeStringList(profileName+" Blacklist",blist)

        }

        function removeDir(idx) {
                dirListModel.remove(idx)
        }

        function removeDirName(name) {
            dirListModel.remove(dirListModel.getIndex(name))
        }

        function addDir(name, type) {
            var idx=dirListModel.getIndex(name)
            if (idx<0) dirListModel.append({ "dirname": name,  "enable": type })
            else dirListModel.set(idx, { "dirname": name,  "enable": type })
        }

        function getIndex(name) {
            var index = 0
            for (var i = 0; i < dirListModel.count; i++)
                if( dirListModel.get(i).dirname === name ) {
                    return i
                }
            return -1
        }

        function isInWhiteList(name) {
            var index = 0
            for (var i = 0; i < dirListModel.count; i++)
                if( dirListModel.get(i).dirname === name && dirListModel.get(i).enable ) {
                    return true
                }
            return false
        }

        function isInBlackList(name) {
            var index = 0
            for (var i = 0; i < dirListModel.count; i++)
                if( dirListModel.get(i).dirname === name && !dirListModel.get(i).enable ) {
                    return true
                }
            return false
        }


    }

    SilicaListView {
        id: viewDirLists
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: parent.width

        header: PageHeader {
            title: qsTr("List of directories")
            description: qsTr("Profile") +" "+ dirsPage.profileName
        }

        model: dirListModel

        VerticalScrollDecorator { flickable: viewDirLists }

        PullDownMenu {
            MenuItem {
                text: qsTr("Add/modify directories")
                onClicked: {
                    dirListModel.writeList()
                    var dirtreeDialog = pageStack.push(Qt.resolvedUrl("DirTree.qml"), {"wblistModel": dirListModel})
                    dirtreeDialog.accepted.connect( function() { dirListModel.writeList(); dirListModel.readList() })
                    dirtreeDialog.rejected.connect( function() { dirListModel.readList() })
                }
            }
        }

        delegate: ListItem {
            id: itemDir
            width: parent.width
            contentHeight: dirLabel.height + Theme.paddingLarge

            menu: ContextMenu {
                MenuItem {
                    text: qsTr("Remove from list")
                    onClicked: remorseDeleteDir(dirname)
                }
            }

            onClicked: {
                dirListModel.writeList()
                var dirtreeDialog = pageStack.push(Qt.resolvedUrl("DirTree.qml"), {"wblistModel": dirListModel, "startPath": dirname})
                dirtreeDialog.accepted.connect(function() { dirListModel.writeList(); dirListModel.readList() })
                dirtreeDialog.rejected.connect( function() { dirListModel.readList() })
            }
            Label {
                id: dirLabel
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: Theme.horizontalPageMargin
                anchors.rightMargin: Theme.horizontalPageMargin
                anchors.verticalCenter: parent.verticalCenter
                wrapMode: Text.Wrap
                text: dirname
                color: itemDir.highlighted ? Theme.highlightColor : Theme.primaryColor
                //font.pixelSize: Theme.fontSizeSmall
            }

            RemorseItem { id: remorse }

            function remorseDeleteDir(name) {
                remorse.execute(itemDir, qsTr("Removing directory from list"),
                                function() {dirListModel.removeDirName(name)}, appWindow.remorseTimeout)
            }
        }

        section.property: "enable"

        section.delegate: ListItem {
            id: sectionDir
            width: parent.width
            enabled: false
            Image {
                id: whiteIcon
                anchors.left: parent.left
                anchors.bottom: parent.bottom
                anchors.leftMargin: Theme.horizontalPageMargin
                source: (section === "true") ? "image://theme/icon-m-acknowledge"  + "?" + Theme.highlightColor
                            : "image://theme/icon-m-dismiss"  + "?" + Theme.highlightColor
            }
            SectionHeader {
                id: sectionDirLabel
                text: (section === "true") ? qsTr("Whitelist directories") : qsTr("Blacklist directories")
                verticalAlignment: Text.AlignBottom

            }

        }
    }

    NotificationPanel {
        id: notificationPanel
        page: dirsPage
    }

}
