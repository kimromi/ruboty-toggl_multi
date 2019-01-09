require 'ruboty/toggl_multi/actions/toggl_multi'

module Ruboty
  module Handlers
    class TogglMulti < Base
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
        /start task (?<task>\S+)(?<project_name>.*)/,
        name: 'start',
        description: 'start toggl task',
        all: true
      )

      on(
        /stop task/,
        name: 'stop',
        description: 'stop toggl task',
        all: true
      )

      def set_token(message)
        action(message).set_token
      end

      def set_workspace(message)
        action(message).set_workspace
      end

      def start(message)
        action(message).start
      end

      def stop(message)
        action(message).stop
      end

      private

      def action(message)
        Ruboty::TogglMulti::Actions::TogglMulti.new(message)
      end
    end
  end
end
