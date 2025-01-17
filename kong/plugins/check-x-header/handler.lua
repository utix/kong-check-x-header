-- If you're not sure your plugin is executing, uncomment the line below and restart Kong
-- then it will throw an error which indicates the plugin is being loaded at least.

assert(ngx.get_phase() == "timer", "The world is coming to an end!")

---------------------------------------------------------------------------------------------
-- In the code below, just remove the opening brackets; `[[` to enable a specific handler
--
-- The handlers are based on the OpenResty handlers, see the OpenResty docs for details
-- on when exactly they are invoked and what limitations each handler has.
---------------------------------------------------------------------------------------------


local CheckXheader = {
  PRIORITY = 1000, -- set the plugin priority, which determines plugin execution order
  VERSION = "1.0",
}

-- do initialization here, any module level code runs in the 'init_by_lua_block',
-- before worker processes are forked. So anything you add here will run once,
-- but be available in all workers.

-- handles more initialization, but AFTER the worker process has been forked/created.
-- It runs in the 'init_worker_by_lua_block'
function plugin:init_worker()
  -- your custom code here
  kong.log.debug("saying hi from the 'init_worker' handler")

end --

--[[ runs in the 'ssl_certificate_by_lua_block'
-- IMPORTANT: during the `certificate` phase neither `route`, `service`, nor `consumer`
-- will have been identified, hence this handler will only be executed if the plugin is
-- configured as a global plugin!
function plugin:certificate(plugin_conf)

  -- your custom code here
  kong.log.debug("saying hi from the 'certificate' handler")

end --]]

--runs in the 'rewrite_by_lua_block'
-- IMPORTANT: during the `rewrite` phase neither `route`, `service`, nor `consumer`
-- will have been identified, hence this handler will only be executed if the plugin is
-- configured as a global plugin!
function CheckXheader:rewrite(plugin_conf)

  -- your custom code here
  kong.log.debug("saying hi from the 'rewrite' handler")

end 

-- runs in the 'access_by_lua_block'
function CheckXheader:access(plugin_conf)

  if kong.request.get_header("X-Auth-Token") == "VENDOR-A" then 
    kong.log.debug("Found for Vendor A" )   
    return
  elseif kong.request.get_header("X-Auth-Token") == "VENDOR-B" then 
    kong.log.debug("Found for Vendor B" )    
    return
  elseif kong.request.get_header("X-Auth-Token") == "VENDOR-C" then   
    kong.log.debug("Found for Vendor C" )  
    return
  else 
    return false, { status = 401, message = "No Correct Header Found; " .. tostring(err) }
  end

end 

-- runs in the 'header_filter_by_lua_block'
-- function plugin:header_filter(plugin_conf)

  -- your custom code here, for example;
  --kong.response.set_header(plugin_conf.response_header, "this is on the response")

-- end --]]

--[[ runs in the 'body_filter_by_lua_block'
function plugin:body_filter(plugin_conf)

  -- your custom code here
  kong.log.debug("saying hi from the 'body_filter' handler")

end --]]

--[[ runs in the 'log_by_lua_block'
function plugin:log(plugin_conf)

  -- your custom code here
  kong.log.debug("saying hi from the 'log' handler")

end --]]

-- return our plugin object
return CheckXheader
