# Ruboty::TogglTeam

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ruboty-toggl_team'
```

## Usage

### Preparation

Set toggl API token. get from [https://toggl.com/app/profile](https://toggl.com/app/profile)

```
ruboty toggl set-token <token>
```

Set workspace(name).

```
ruboty toggl set-workspace <workspace-name>
```

### Get project names

```
projects
```
### Start task

```
start <task>
start <task> <project-name>
```

### Stop task

```
stop
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kimromi/ruboty-toggl_team. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Ruboty::TogglTeam project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/kimromi/ruboty-toggl_team/blob/master/CODE_OF_CONDUCT.md).
