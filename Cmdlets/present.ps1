$typeDef = @"
using System;
using System.Runtime.InteropServices;

public static class QueryUserNotificationState
{
    public enum UserNotificationState
    {
        /// <summary>
        /// A screen saver is displayed, the machine is locked,
        /// or a nonactive Fast User Switching session is in progress.
        /// </summary>
        NotPresent = 1,

        /// <summary>
        /// A full-screen application is running or Presentation Settings are applied.
        /// Presentation Settings allow a user to put their machine into a state fit
        /// for an uninterrupted presentation, such as a set of PowerPoint slides, with a single click.
        /// </summary>
        Busy = 2,

        /// <summary>
        /// A full-screen (exclusive mode) Direct3D application is running.
        /// </summary>
        RunningDirect3dFullScreen = 3,

        /// <summary>
        /// The user has activated Windows presentation settings to block notifications and pop-up messages.
        /// </summary>
        PresentationMode = 4,

        /// <summary>
        /// None of the other states are found, notifications can be freely sent.
        /// </summary>
        AcceptsNotifications = 5,

        /// <summary>
        /// Introduced in Windows 7. The current user is in "quiet time", which is the first hour after
        /// a new user logs into his or her account for the first time. During this time, most notifications
        /// should not be sent or shown. This lets a user become accustomed to a new computer system
        /// without those distractions.
        /// Quiet time also occurs for each user after an operating system upgrade or clean installation.
        /// </summary>
        QuietTime = 6
    }

    [DllImport("shell32.dll")]
    static extern int SHQueryUserNotificationState(out UserNotificationState userNotificationState);

    public static UserNotificationState GetState()
    {
        UserNotificationState state;
        var returnVal = SHQueryUserNotificationState(out state);

        return state;
    }
}
"@

Add-Type -TypeDefinition $typeDef -PassThru | Out-Null

function Get-UserNotificationState {
    [QueryUserNotificationState]::GetState()
}

function Start-PresentationMode {
    & PresentationSettings /start
    while ([QueryUserNotificationState]::GetState() -ne 'PresentationMode') { }
    [QueryUserNotificationState]::GetState()
}

function Stop-PresentationMode {
    & PresentationSettings /stop
    while ([QueryUserNotificationState]::GetState() -eq 'PresentationMode') { }
    [QueryUserNotificationState]::GetState()
}
