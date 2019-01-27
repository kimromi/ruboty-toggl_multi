require 'ruboty/toggl_team/actions/toggl_team'

module Ruboty
  module Handlers
    class TogglTeam < Base
      on(
        /toggl set-token (?<token>.+)/,
        name: 'set_token',
        description: 'set toggl user token'
      )

      on(
        /toggl set-workspace (?<name>.+)/,
        name: 'set_workspace',
        description: 'set toggl workspace name'
      )

      on(
        /^projects$/,
        name: 'projects',
        description: 'get projects',
        all: true
      )

      on(
        /^start (?<task>\S+)(?<project_name>.*)/,
        name: 'start',
        description: 'start toggl task',
        all: true
      )

      on(
        /^stop$/,
        name: 'stop',
        description: 'stop toggl task',
        all: true
      )

      on(
        /^today$/,
        name: 'today',
        description: 'get today time report',
        all: true
      )

      def set_token(message)
        action(message).set_token
      end

      def set_workspace(message)
        action(message).set_workspace
      end

      def projects(message)
        action(message).projects
      end

      def start(message)
        action(message).start
      end

      def stop(message)
        action(message).stop
      end

      def today(message)
        action(message).today
      end

      private

      def action(message)
        Ruboty::TogglTeam::Actions::TogglTeam.new(message)
      end
    end
  end
end
