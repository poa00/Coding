# ------------------------------------------------------------
#
# Royal TS
#   |--> Key Sequence, Open "Local Users and Groups" (lusrmgr.msc)
#
# ------------------------------------------------------------
#
# OPTION 1 (Primary)
#

{ESC}{WAIT:250}{LWIN}{WAIT:250}%WINDIR%\System32\lusrmgr.msc{WAIT:500}{ENTER}{WAIT:750}{LEFT}{WAIT:500}{ENTER}


# ------------------------------------------------------------
#
# OPTION 2 (Secondary)
#

{ESC}{WAIT:250}{LWIN}{WAIT:250}cmd.exe{WAIT:100}{ENTER}{WAIT:750}powershell.exe Start-Process 'C:\Windows\System32\lusrmgr.msc' -Verb RunAs;{ENTER}{WAIT:750}{LEFT}{WAIT:500}{ENTER}{WAIT:500}


# ------------------------------------------------------------
#
# OPTION 3 (Fallback)
#

{HOLD:WIN}{WAIT:10}X{WAIT:10}{RELEASE:WIN}{WAIT:500}A{WAIT:500}{LEFT}{WAIT:1000}{ENTER}{WAIT:2000}lusrmgr.msc & exit{ENTER}


# ------------------------------------------------------------
