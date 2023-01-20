# Load the Winforms assembly
[reflection.assembly]::LoadWithPartialName( "System.Windows.Forms")

# Create the form
$form = New-Object Windows.Forms.Form


#Set window size
$form.ClientSize = '600,400'

#Set the dialog title
$form.text = "Starlux Install Wizard"

#Create Checkbox
$checkbox = New-Object Windows.Forms.Checkbox
$checkbox.Location = New-Object Drawing.Point 50,60
$checkbox.Size = New-Object Drawing.Point 200,30
$checkbox.Text = "Testing"

# Create the label control and set text, size and location
$label = New-Object Windows.Forms.Label
$label.Location = New-Object Drawing.Point 50,30
$label.Size = New-Object Drawing.Point 200,15
$label.text = "Enter your name and click the button"

# Create TextBox and set text, size and location
$textfield = New-Object Windows.Forms.TextBox
$textfield.Location = New-Object Drawing.Point 50,60
$textfield.Size = New-Object Drawing.Point 200,30

# Create Button and set text and location
$button = New-Object Windows.Forms.Button
$button.text = "Greeting"
$button.Location = New-Object Drawing.Point 100,90

# Set up event handler to extarct text from TextBox and display it on the Label.
$button.add_click({

$label.Text = "Hello " + $textfield.text

})

# Add the controls to the Form
$form.controls.add($button)
$form.controls.add($label)
$form.controls.add($checkbox)

# Display the dialog
$form.ShowDialog()