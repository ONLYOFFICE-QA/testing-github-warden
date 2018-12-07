# Testing githib warden 
### How to run
Change dockerfile: need to add `SECRET_TOKEN` and `BUGZILLA_API_KEY`

```
docker build . -t testing-github-warden
docker run -itd testing-github-warden
```

* `SECRET_TOKEN` - is a token from webhook settings (https://developer.github.com/webhooks/securing/)
* `BUGZILLA_API_KEY` - is a key from bugzilla (https://bugzilla.readthedocs.io/en/latest/integrating/auth-delegation.html)

### How it work?
After any push to repo, that we activate webhooks, github will sent post request to serve.
This request contains repository name, branch name, commit message and other data.
Server take all of them, and if repository name, branch name and commit of message is matched with pattern, action will be executed

### Adding new event
#### New pattern
At first, need to add new pattern to `config/warden_config.yml`

Example:

```
  :repository_name_pattern: 'repo_name'
  :branch_name_pattern: 'branch_name'
  :commit_message_pattern: 'commit message'
  :action: 'action'
```
All of this fields is a regular expression, but don't need to add `/` `/`  in start and end in this.
Repository name is shot name of repository(without username)
Branch name is comming in string like ``refs/heads/branch_name``
Action is a custom name of action. Feel free to set something.

#### New action

All actions is placed in `helpers/hook_direction.rb`, in `run_action` method.
You need to add new `when your_action_name`, and it will execute when all of patterns in one block will be match

