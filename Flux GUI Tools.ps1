Add-Type -AssemblyName System.Windows.Forms

# Prompt the user to select the folder containing batch files
$batchFolderDialog = New-Object System.Windows.Forms.FolderBrowserDialog
$batchFolderDialog.Description = "Select a folder containing batch files"
$batchFolderDialog.ShowNewFolderButton = $false
$batchFolderResult = $batchFolderDialog.ShowDialog()

if ($batchFolderResult -eq 'OK') {
    # Prompt the user to select the batch file to exclude
    $excludeBatchDialog = New-Object System.Windows.Forms.OpenFileDialog
    $excludeBatchDialog.InitialDirectory = $batchFolderDialog.SelectedPath
    $excludeBatchDialog.Title = "Select a batch file to exclude"
    $excludeBatchDialog.Filter = "Batch Files (*.bat)|*.bat|All Files (*.*)|*.*"
    $excludeBatchResult = $excludeBatchDialog.ShowDialog()

    if ($excludeBatchResult -eq 'OK') {
        $excludeBatchName = (New-Object System.IO.FileInfo -ArgumentList $excludeBatchDialog.FileName).Name

        # Get all batch files in the selected folder except the one to exclude
        $files = Get-ChildItem $batchFolderDialog.SelectedPath -Filter *.bat | Where-Object { $_.Name -ne $excludeBatchName }

        # Create a new form and add a ListView control
        $form = New-Object System.Windows.Forms.Form
        $form.Text = "Flux Tools GUI"
        $form.Size = New-Object System.Drawing.Size(300, 200)
        $form.StartPosition = "CenterScreen"

        $listView = New-Object System.Windows.Forms.ListView
        $listView.Location = New-Object System.Drawing.Point(10, 10)
        $listView.Size = New-Object System.Drawing.Size(270, 140)
        $listView.View = [System.Windows.Forms.View]::Details
        $listView.FullRowSelect = $true

        # Add columns to the ListView
        $listView.Columns.Add("Name", 200) | Out-Null
        $listView.Columns.Add("Path", 0) | Out-Null

        # Add batch files as items to the ListView
        foreach ($file in $files) {
            $item = New-Object System.Windows.Forms.ListViewItem
            $item.Text = $file.Name
            $item.SubItems.Add($file.FullName)
            $listView.Items.Add($item) | Out-Null
        }

        # Add a click event to the ListView items
        $listView.Add_Click({
            $item = $listView.SelectedItems[0]
            $batchFilePath = $item.SubItems[1].Text
            $cmd = "`"$batchFilePath`""
            Start-Process "cmd.exe" "/c $cmd" -WorkingDirectory $batchFolderDialog.SelectedPath
        })

        $form.Controls.Add($listView)

        # Show the form and wait for it to close
        $form.Add_Shown({ $form.Activate() })
        $form.ShowDialog()

        # Clean up the ListView when the form is closed
        $listView.Dispose()
    }
}
