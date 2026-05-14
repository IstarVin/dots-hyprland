function get_proper_workspace(workspace)
    local curr_workspace = hl.get_active_workspace().id
    return (curr_workspace - (curr_workspace % 10)) + workspace
end
