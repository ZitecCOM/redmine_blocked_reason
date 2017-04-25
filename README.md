# Redmine Blocked Reason

[![Build Status](https://travis-ci.org/zitec/redmine_blocked_reason.svg?branch=master)](https://travis-ci.org/zitec/redmine_blocked_reason)

## Plugin administration page

The administration page contains 3 features:
1. create button for 'block reason' entities 
2. grid listing the 'block reasons'
3. delete button for each 'block reason' 

![Administration page](images/administration_page.png?raw=true "Administration page")


To add a new reason, simply press on the 'New Type' button from the upper right corner.    
Name the reason and select a level type:
- danger - it will be displayed with red background (for important reasons)
- info - it will be displayed with gray background (for neutral reasons)
- success - it will be displayed with green background.    

![Create new reason](images/create.png?raw=true "Create new reason")


## Blocking an issue

When you view an issue, you should see a new button 'Mark as blocked'.    
Clicking on it will open a modal, containing the previously configured reasons:
![Blocked reasons](images/block_reasons.png?raw=true "Blocked reasons")

To block an issue: click on 'marked as block', choose one reason, add a comment, submit.

## 

When listing issues, those that are 'marked as blocked' will be visible in grid that with a 'blocked reason' tag.   
If you hover over the 'blocked' tag, the reason will be displayed.
In the sidebar, you can also see how many issues from the project are marked as blocked.  
By clicking on a tag, a query will be made to display all open issues that have that particular reason. 

![List blocked issues](images/list_blocked_issues.png?raw=true "list blocked issues")

## Unblocking
To mark the issue as unblock by either:
- change the status, and will auto-unblock
- click again on the 'mark as blocked' and choose 'Remove'
