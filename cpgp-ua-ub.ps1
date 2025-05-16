# This takes all user groups assigned to UserA, and assigns them to UserB
# Does not remove any user groups from UserB
$userA = "UserA" # enter in username of the main user
$userB = "UserB" # enter in username of the user you want to copy the groups to
Get-ADUser -Identity $userA -Properties memberof | Select-Object -ExpandProperty memberof | ForEach-Object { Add-ADGroupMember -Identity $_ -Members $userB }
