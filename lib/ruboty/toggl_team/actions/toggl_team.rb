require 'togglv8'
require 'active_support/core_ext/hash/keys'
require 'active_support/core_ext/time/calculations'

module Ruboty
  module TogglTeam
    module Actions
      class TogglTeam < Ruboty::Actions::Base
        BRAIN_KEY_TOKENS = 'toggl_team_tokens'.freeze
        BRAIN_KEY_WORKSPACES = 'toggl_team_workspaces'.freeze

        def set_token
          tokens = brain.data[BRAIN_KEY_TOKENS] || {}
          tokens[user] = message.match_data[:token].strip
          brain.data[BRAIN_KEY_TOKENS] = tokens

          message.reply("set #{user}'s toggl token!")
        end

        def set_workspace
          unless user_token
            message.reply("please set #{user}'s toggl token!")
            return
          end

          name = message.match_data[:name].strip
          workspace = toggl.my_workspaces.find {|w| w['name'] == name }

          if workspace
            workspaces = brain.data[BRAIN_KEY_WORKSPACES] || {}
            workspaces[user] = workspace
            brain.data[BRAIN_KEY_WORKSPACES] = workspaces
            message.reply("set #{name} workspace to #{user}!")
          else
            message.reply("#{name} workspace not found!")
          end
        rescue => e
          message.reply("error! #{e}")
        end

        def projects
          unless user_token && user_workspace
            message.reply("please set #{user}'s toggl token and workspace!") and return
          end

          projects =  toggl.projects(user_workspace['id'], active: true)
          message.reply(projects.map {|p| p['name'] }.join("\n"))
        end

        def start
          unless user_token && user_workspace
            message.reply("please set #{user}'s toggl token and workspace!") and return
          end

          task = message.match_data[:task].strip

          project_name = message.match_data[:project_name].strip
          project = toggl.projects(user_workspace['id'], active: true)&.find do |p|
            p['name'] =~ /#{project_name != '' ? project_name : task}/
          end

          entry = toggl.start_time_entry({
            description: task,
            wid: user_workspace['id'],
            pid: project ? project['id'] : nil
          }.stringify_keys)

          message.reply("started #{task}#{project ? ' in ' + project['name'] : ''}.")
        rescue => e
          message.reply("error! #{e}")
        end

        def stop
          unless user_token && user_workspace
            message.reply("please set #{user}'s toggl token and workspace!") and return
          end

          if current = toggl.get_current_time_entry
            toggl.stop_time_entry(current['id'])
            message.reply('task stopped.')
          else
            message.reply('not running task.')
          end
        rescue => e
          message.reply("error! #{e}")
        end

        def today
          unless user_token && user_workspace
            message.reply("please set #{user}'s toggl token and workspace!") and return
          end

          entries = toggl.get_time_entries(
            start_date: DateTime.parse(Time.now.beginning_of_day.to_s),
            end_date: DateTime.parse(Time.now.end_of_day.to_s)
          )

          report = entries.map do |e|
            start_at = Time.parse(e['start']).localtime.strftime('%R')
            end_at = Time.parse(e['stop']).localtime.strftime('%R')
            "#{start_at}-#{end_at} : #{e['description']}"
          end.join("\n")

          message.reply(report)
        end

        private

        def brain
          message.robot.brain
        end

        def user
          message.from_name || 'test'
        end

        def user_token
          user_tokens = brain.data[BRAIN_KEY_TOKENS] || {}
          user_tokens[user]
        end

        def user_workspace
          user_workspaces = brain.data[BRAIN_KEY_WORKSPACES] || {}
          user_workspaces[user]
        end

        def toggl
          TogglV8::API.new(user_token)
        end
      end
    end
  end
end
