local typedefs = require "kong.db.schema.typedefs"


local PLUGIN_NAME = "api-transform"


local schema = {
  name = PLUGIN_NAME,
  fields = {
    -- the 'fields' array is the top-level entry with fields defined by Kong
    { consumer = typedefs.no_consumer },  -- this plugin cannot be configured on a consumer (typical for auth plugins)
    { protocols = typedefs.protocols_http },
    { config = {
        -- The 'config' record is the custom part of the plugin schema
        type = "record",
        fields = {
          -- a standard defined field (typedef), with some customizations
          -- { response_header = typedefs.header_name {
          --     required = true,
          --     default = "Bye-World" } },
          { raw_string = { -- self defined field
              type = "string",
              default = "API-Response",
              required = true,
            }
          }, -- adding a constraint for the value
        },
      },
    },
  },
}

return schema
