# Testing githib warden

## How to run

Change dockerfile: need to add `SECRET_TOKEN` and `BUGZILLA_API_KEY`

Or from docker-compose

```shell
docker-compose up -d
```

There are easy way to update warden if you use docker-compose

```shell
docker-compose up --build -d
```

Don't forget to change important variables from docker_compose file:

* `SECRET_TOKEN` - is a token from [webhook settings](https://developer.github.com/webhooks/securing/)
* `BUGZILLA_API_KEY` - is a key from [bugzilla](https://bugzilla.readthedocs.io/en/latest/integrating/auth-delegation.html)

## How it works

After any push to repo, that we activate webhooks, github will
sent post request to server.
This request contains commit message and other data.
Server take all of them, and if message of commit is matched
with pattern, and if commit has pushed to allowed repository
and to allowed branch, action will be added to redis queue.
Actions will not be perform if bug is contains comment with hash of commit.

At now, there are two actions: add comment and change status to RESOLVED.

* If commit message contain word "Bug" (or "bug"),
  and after it will be placed number (like "123456", or "#123456"),
  this bug will be commented.
* If commit message contain word "Fix" (or "Fixed") +
  "Bug" (or "bug") +  number (like "123456", or "#123456"),
  bug with id "123456" will be commented, and status will be changed.
* Only "NEW", "REOPENED" or "ASSIGNED" statuses can be changed

Examples for changing status and commented:
"Fix bug 123456", "fixed bug #123456 and other message", "FIxEd bUg #123456"

Examples for only comments:
"For Bug #123456", "This text have no matter bUG 123456"

**WARNING** You can only close one bug via single commit.
Until [#82](https://github.com/ONLYOFFICE-QA/testing-github-warden/issues/82)
is resolved

## Adding new repo to list of repos

This process consists or three steps:

1. Add repo to `config/allowed_branches.yml`. Example is PR like [that](https://github.com/ONLYOFFICE-QA/testing-github-warden/pull/564)
2. Update backend service, what running on one of our servers.
  Only server administrators can do that.
3. On repository side - new WebHook registration is required.
Go to `Settings` -> `Webhooks` -> `Add webhook` and  
fill form like on screenshot below:

![Webhook settings screenshot](https://github.com/ONLYOFFICE-QA/testing-github-warden/assets/154601125/2bde6cc2-ccc4-48d6-978a-f3fa2ac595fb "Webhook settings screenshot")

## Adding new event

Config for new pattern: `config/warden_config.yml`

Example:

```yaml
  :commit_message_pattern: 'commit message'
  :action: 'action'
```

All of this fields is a regular expression,
but don't need to add `/` `/`  in start and end in this.
Action is a custom name of action. Feel free to set something.

## Adding repository and branch to allowed

Need to change `config/allowed_branches.yml` for adding repositories
and branches to allowed list.
Example:

```yaml
    -
        :repository_name_array: ['repo_name']
        :branch_pattern: 'branch_name|other_branch_name'
```

repository_name_array must be array, branch_pattern must be regexp

## For developer

`testing-github-warden` is contains of 3 services: `redis`,
`warden` and `executer`.

* Redis must share socket for work.
* Warden listen 3000 port and push data for actions to redis.
* Executer listen redis and execute every action.

## For testing

Run server and tests in same keys:

```bash
SECRET_TOKEN='1234' BUGZILLA_API_KEY='<api key>' docker-compose up -d
SECRET_TOKEN='1234' BUGZILLA_API_KEY='<api key>' bundle exec rspec spec/tests/
```

## For debugging

If you want to debugging server, you need to run it without docker.

For running server on debug, use `config.ru` file,
and don't forget to add env variables to this file
if you using IDE with special environment space (like rubymine)

For running test on debug, change `spec/data/static_data.rb:PORT` to `9292`,
and add env variables to `spec/spec_helper.rb`

## How to release new version (for maintainers)

1. Update `VERSION` file
2. Update `CHANGELOG.md` by adding version line after `master (unreleased)`
3. Create PR with those changes and merge to `master`
4. On `master` run `rake add_repo_tag`
5. On `GitHub` create new release via web-browser and add info from `CHANGELOG.md`