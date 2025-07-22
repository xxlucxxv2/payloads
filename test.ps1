for ($i = 1; $i -le 10; $i++) {
    # Start Notepad
    $proc = Start-Process notepad -PassThru

    # Wait a moment for the window to be created
    Start-Sleep -Milliseconds 300

    # Get the main window handle and set random position
    $sig = '
        [DllImport("user32.dll")] public static extern bool MoveWindow(IntPtr hWnd, int X, int Y, int nWidth, int nHeight, bool bRepaint);
        [DllImport("user32.dll")] public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
    '
    Add-Type -MemberDefinition $sig -Name "Win32" -Namespace WinAPI

    $notepad = Get-Process -Id $proc.Id
    $hWnd = $notepad.MainWindowHandle

    if ($hWnd -ne 0) {
        $screenWidth = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Width
        $screenHeight = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Height

        $rand = Get-Random -Minimum 0 -Maximum ($screenWidth - 400)
        $randY = Get-Random -Minimum 0 -Maximum ($screenHeight - 300)

        # Move the window
        [WinAPI.Win32]::MoveWindow($hWnd, $rand, $randY, 400, 300, $true)
    }

    Start-Sleep -Milliseconds 300
}

