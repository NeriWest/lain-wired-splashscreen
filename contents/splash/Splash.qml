/*
 *   Copyright 2014 Marco Martin <mart@kde.org>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License version 2,
 *   or (at your option) any later version, as published by the Free
 *   Software Foundation
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details
 *
 *   You should have received a copy of the GNU General Public
 *   License along with this program; if not, write to the
 *   Free Software Foundation, Inc.,
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

/*
 * Forked by Edson Kiel Perez 2025
 * Original by: Marco Martin
 * Inspired and source from:
 * a. https://heartthrobbingworld.neocities.org/
 * b. https://fauux.neocities.org/login
 *
 */

import QtQuick 2.5
import QtQuick.Window 2.2

Rectangle {
    id: root
    color: "#000000"

    property int stage

    onStageChanged: {
        if (stage == 1) {
            introAnimation.running = true;
            dotAnimationTimer.start();
        } else if (stage == 3) {
            introAnimation.duration = 2000;
            introAnimation.target = busyIndicator;
            introAnimation.from = 1;
            introAnimation.to = 0;
            introAnimation.running = true;

            // Stop dot animation and show static text
            dotAnimationTimer.stop();
            statusText.dotCount = 0; // Reset to no dots
            statusText.text = statusText.authenText; // Force static text

        } else if (stage == 6) {
            statusText.text = statusText.finishText; // Force static text

        }
    }

    Item {
        id: content
        anchors.fill: parent
        opacity: 0
        TextMetrics {
            id: units
            text: "M"
            property int gridUnit: boundingRect.height
            property int largeSpacing: units.gridUnit
            property int smallSpacing: Math.max(2, gridUnit/4)
        }

        Rectangle {
            property int sizeAnim: 1920
            id: imageSource
            width: sizeAnim
            height: sizeAnim
            color: "transparent"
            anchors.centerIn: parent
            clip: true

            AnimatedImage {
                id: face
                source: "images/copland.gif"
                anchors.centerIn: parent
                width: Math.min(parent.width, 1920)
                height: Math.min(parent.height, 1080)
                fillMode: Image.PreserveAspectFit
                smooth: false
            }
        }

        Image {
            id: busyIndicator
            y: parent.height - 0
            anchors.horizontalCenter: parent.horizontalCenter
            source: "images/busywidget.svgz"
            sourceSize.height: units.gridUnit * 2
            sourceSize.width: units.gridUnit * 2
            RotationAnimator on rotation {
                from: 0; to: 360; duration: 3000; loops: Animation.Infinite
            }
        }

        Text {
            id: statusText
            color: "#c1b492"
            anchors {
                bottom: parent.bottom
                horizontalCenter: parent.horizontalCenter
                bottomMargin: units.gridUnit * 12
            }
            font.pixelSize: 20
            font.letterSpacing: 1.8
            renderType: Text.NativeRendering
            textFormat: Text.RichText

            property string baseText: "<b>Booting up</b>: The Wired" // You can change your "PC name" here if you want ^^
            property string authenText: "<b>Authenticating</b>: usr/Lain" //You can also change your "Username" here ^^
            property string finishText: "<b>Connection established</b>: The Wired"
            property int dotCount: 0

            // Use color transparency instead of opacity
            property string dotHtml:
            "<font color='" + (dotCount > 0 ? "#c1b492" : "#00000000") + "'>.</font>" +
            "<font color='" + (dotCount > 1 ? "#c1b492" : "#00000000") + "'>.</font>" +
            "<font color='" + (dotCount > 2 ? "#c1b492" : "#00000000") + "'>.</font>"

            text: baseText + dotHtml
        }
    }

    Timer {
        id: dotAnimationTimer
        interval: 700
        running: false
        repeat: true
        onTriggered: statusText.dotCount = (statusText.dotCount + 1) % 4
    }

    //probably even doesn't work://'
    Timer {
        id: minimumDisplayTimer
        interval: 3000  // 3 seconds (adjust as needed)
        running: false
        onTriggered: console.log("Minimum display time elapsed") // Optional
    }

    OpacityAnimator {
        id: introAnimation
        target: content
        from: 0; to: 1; duration: 1000; easing.type: Easing.InOutQuad
    }
}
