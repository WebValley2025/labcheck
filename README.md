# labcheck
Let's get started!


# Environment set up for WebValley2025 on Azure Lab

>## Are you a Windows user?
>### Open Windows PowerShell with Administratory Rights
>
>`# Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0`

## Open a terminal and
## connect to the virtual machine (VM)
`ssh -L 8888:localhost:8888 -p MY_VIRTUAL_MACHINE_PORT wvuser@MY_VIRTUAL_MACHINE_NAME.westeurope.cloudapp.azure.com`

## Activate the virtual environment called `.venv`
`source ...`

## Start jupyter lab
`jupyter lab --no-browser`

Navigate to http://localhost:8888/lab

# Now let's connect through VSCode

Open VSCode and open a new Remote Connection
