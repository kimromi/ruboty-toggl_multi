require 'togglv8'
require 'active_support/core_ext/hash/keys'

module Ruboty
  module TogglMulti
    module Actions
      class TogglMulti < Ruboty::Actions::Base
        BRAIN_KEY_TOKENS = 'toggl_multi_tokens'.freeze
        BRAIN_KEY_WORKSPACE = 'toggl_multi_workspace'.freeze

        def set_token
          tokens = brain.data[BRAIN_KEY_TOKENS] || {}
          tokens[user] = message.match_data[:token].strip
          brain.data[BRAIN_KEY_TOKENS] = tokens

          message.reply("set #{user}'s toggl token!")
        end

        def set_workspace
          unless user_tokens.key?(user)
            message.reply("please set #{user}'s toggl token!")
            return
          end

          name = message.match_data[:name].strip
          workspace = toggl.my_workspaces.find {|w| w['name'] == name }

          if workspace
            brain.data[BRAIN_KEY_WORKSPACE] = workspace
            message.reply("set #{name} workspace!")
          else
            message.reply("#{name} workspace not found!")
          end
        rescue => e
          message.reply("error! #{e}")
        end

        def start
          if !user_tokens.key?(user) || !workspace_id
            message.reply("please set #{user}'s toggl token and workspace!") and return
          end

          project_name = message.match_data[:project_name].strip
          project = if project_name != ''
            toggl.projects(workspace_id, active: true)&.find {|p| p['name'] =~ /#{project_name}/ }
          end

          task = message.match_data[:task].strip
          entry = toggl.start_time_entry({
            description: task,
            wid: workspace_id,
            pid: project ? project['id'] : nil
          }.stringify_keys)

          message.reply("started #{task}#{project ? ' in ' + project['name'] : ''}.")
        rescue => e
          message.reply("error! #{e}")
        end

        def stop
          if !user_tokens.key?(user) || !workspace_id
            message.reply("please set #{user}'s toggl token and workspace!") and return
          end

          if current = toggl.get_current_time_entry
            toggl.stop_time_entry(current['id'])
            message.reply('task stopped')
          else
            message.reply('not running task.')
          end
        rescue => e
          message.reply("error! #{e}")
        end

        private

        def brain
          message.robot.brain
        end

        def user_tokens
          brain.data[BRAIN_KEY_TOKENS] || {}
        end

        def workspace_id
          if w = brain.data[BRAIN_KEY_WORKSPACE]
            w['id']
          else
            nil
          end
        end

        def user_current_tasks
          brain.data[BRAIN_KEY_TOKENS] || {}
        end

        def user
          message.from_name || 'test'
        end

        def toggl
          TogglV8::API.new(user_tokens[user])
        end
      end
    end
  end
end
