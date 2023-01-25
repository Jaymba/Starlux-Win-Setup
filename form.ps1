# Load the Winforms assembly
[reflection.assembly]::LoadWithPartialName( "System.Windows.Forms")

# Create the form
$form = New-Object Windows.Forms.Form

#Customize window 
$form.ClientSize = '600,400' 

#Set the dialog title
$form.text = "Starlux Install Wizard"

#Create Checkboxs
$g_checkbox = New-Object Windows.Forms.Checkbox
$g_checkbox.Location = New-Object Drawing.Point 50,30
$g_checkbox.Size = New-Object Drawing.Point 150,30
$g_checkbox.Text = "Guardian Group Policy"

$v_checkbox = New-Object Windows.Forms.Checkbox
$v_checkbox.Location = New-Object Drawing.Point 50,60
$v_checkbox.Size = New-Object Drawing.Point 150,30
$v_checkbox.Text = "Video"

$i_checkbox = New-Object Windows.Forms.Checkbox
$i_checkbox.Location = New-Object Drawing.Point 50,90
$i_checkbox.Size = New-Object Drawing.Point 150,30
$i_checkbox.Text = "Images"

#Create Dropdown

# Create the label control and set text, size and location
#$label = New-Object Windows.Forms.Label
#$label.Location = New-Object Drawing.Point 50,30
#$label.Size = New-Object Drawing.Point 200,15
#$label.text = "Enter your name and click the button"

# Create TextBox and set text, size and location
#$textfield = New-Object Windows.Forms.TextBox
#$textfield.Location = New-Object Drawing.Point 50,60
#$textfield.Size = New-Object Drawing.Point 200,30

# Create Button and set text and location
$button = New-Object Windows.Forms.Button
$button.text = "Greeting"
$button.Location = New-Object Drawing.Point 100,90

# Set up event handler to extarct text from TextBox and display it on the Label.




$button.add_click({

$label.Text = "Hello " + $textfield.text

})

# Add the controls to the Form
#$form.controls.add($button)
#$form.controls.add($label)
$form.controls.add($g_checkbox)
$form.controls.add($v_checkbox)
$form.controls.add($i_checkbox)

# Display the dialog
$form.ShowDialog()