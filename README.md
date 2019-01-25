# Testing githib warden 
### How to run
Change dockerfile: need to add `SECRET_TOKEN` and `BUGZILLA_API_KEY`


You cat build and run application from Docker
```
docker build . -t testing-github-warden
docker run -itd -p 3000:3000 --restart always --name github-warden testing-github-warden
```

Or from docker-compose
```
docker-compose up -d
```

There are easy way to update warden if you use docker-compose
```
docker-compose up --build -d
```

* `SECRET_TOKEN` - is a token from webhook settings (https://developer.github.com/webhooks/securing/)
* `BUGZILLA_API_KEY` - is a key from bugzilla (https://bugzilla.readthedocs.io/en/latest/integrating/auth-delegation.html)

### How it work?
After any push to repo, that we activate webhooks, github will sent post request to serve.
This request contains commit message and other data.
Server take all of them, and if message of commit is matched with pattern, action will be executed


At now, there are two actions: add comment and change status to RESOLVED.
* If commit message contain word "Bug" (or "bug"), and after it will be placed number (like "123456", or "#123456"), this bug will be commented.
* If commit message contain word "Fix" (or "Fixed") + "Bug" (or "bug") +  number (like "123456", or "#123456"), bug with id "123456" will be commented, and status will be changed.
* Only "NEW", "REOPENED" or "ASSIGNED" statuses can be changed

Examples for changing status and commented:
"Fix bug 123456", "fixed bug #123456 and other message", "FIxEd bUg #123456"

Examples for only comments:
"For Bug #123456", "This text have no matter bUG 123456"

### Adding new event
#### New pattern
At first, need to add new pattern to `config/warden_config.yml`

Example:

```
  :commit_message_pattern: 'commit message'
  :action: 'action'
```
All of this fields is a regular expression, but don't need to add `/` `/`  in start and end in this.
Action is a custom name of action. Feel free to set something.

#### New action

All actions is placed in `helpers/hook_direction.rb`, in `run_action` method.
You need to add new `when your_action_name`, and it will execute when all of patterns in one block will be match

