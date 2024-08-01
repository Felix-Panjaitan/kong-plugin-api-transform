local cjson = require "cjson"

local plugin = {
  PRIORITY = 1000, -- set the plugin priority, which determines plugin execution order
  VERSION = "0.1", -- version in X.Y.Z format. Check hybrid-mode compatibility requirements.
}


--[[ runs in the 'rewrite_by_lua_block'
-- IMPORTANT: during the `rewrite` phase neither `route`, `service`, nor `consumer`
-- will have been identified, hence this handler will only be executed if the plugin is
-- configured as a global plugin!
function plugin:rewrite(plugin_conf)

  -- your custom code here
  kong.log.debug("saying hi from the 'rewrite' handler")

end --]]


--[[ runs in the 'access_by_lua_block'
function plugin:access(plugin_conf)

  -- your custom code here
  kong.log.inspect(plugin_conf)   -- check the logs for a pretty-printed config!
  kong.service.request.set_header(plugin_conf.request_header, "this is on a request")

end --]]


-- runs in the 'header_filter_by_lua_block'
function plugin:header_filter(plugin_conf)

  -- your custom code here, for example;
  local json_head = kong.response.get_header("Content-Type")

  if json_head == 'application/json' then
    kong.response.set_header("Content-Type", "application/json")
  end
  -- kong.response.set_header(plugin_conf.response_header, "this is on the response")

end --]]

-- runs in the 'body_filter_by_lua_block'

function plugin:body_filter(plugin_conf)

  kong.log.inspect(plugin_conf)

  -- your custom code here
  local raw_string = kong.response.get_raw_body()

  if raw_string then
    local lua_table = {
      message = raw_string
    }
    local json_body = cjson.encode(lua_table)

    kong.response.set_raw_body(json_body)
  else 
    return kong.response.exit(400, "No Response Available...")
  end

  kong.log.debug("saying hi from the 'body_filter' handler")

end --]]


--[[ runs in the 'log_by_lua_block'
function plugin:log(plugin_conf)

  -- your custom code here
  kong.log.debug("saying hi from the 'log' handler")

end --]]


-- return our plugin object
return plugin
