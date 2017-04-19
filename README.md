# Redmine Blocked Reason

[![Build Status](https://travis-ci.org/zitec/redmine_blocked_reason.svg?branch=master)](https://travis-ci.org/zitec/redmine_blocked_reason)

## Plugin administration page

The administration page contains 3 elements:
1. create button for 'block reason' entities
2. grid listing the 'block reasons'
3. delete button for each 'block reason' 

![Administration page](images/administration_page.png?raw=true "Administration page")


To add a new reason, simply press on the 'New Type' button from the upper right corner.    
Name the reason, and select a level type:
- danger - it will be displayed with red background (for important reasons)
- info - it will be displayed with gray background (for neutral reasons)
- success - it will be displayed with green background.    

## Blocking an issue

When you go to the issues' page, you should see a new button 'Mark as blocked'. Pressing on it displays a modal, containing the reasons you previously configured:

![Blocked reasons](images/block_reasons.png?raw=true "Blocked reasons")

Choose one reason, add a comment, submit.

When you listing issues, those that are blocked are visible in grid, and if you hover over the 'blocked' tag, the reason will be displayed in a popup.
You can also see how many issues from the project are blocked, in sidebar - the section 'Blocked Reasons'. By clicking on a tag, a query will be made for that particular tag. 

![List blocked issues](images/list_blocked_issues.png?raw=true "list blocked issues")


## Unblocking
To mark the issue as unblock, you either change the status, or click again on the mark as blocked and choose 'Remove'