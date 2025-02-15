{ config, ... }:
{
  programs.htop = {
    enable = true;
    settings = {
      color_scheme = 0;
      cpu_count_from_one = 1;
      delay = 15;
      enable_mouse = 1;
      hide_kernel_threads = 1;
      hide_userland_threads = 1;
      highlight_base_name = 1;
      highlight_deleted_exe = 0;
      highlight_megabytes = 1;
      highlight_threads = 1;
      highlight_changes = 0;
      highlight_changes_delay_secs = 5;
      header_layout = "two_50_50";
      column_meters_0 = "AllCPUs Blank Memory";
      column_meter_modes_0 = "1 2 1";
      column_meters_1 = "Tasks LoadAverage Blank DiskIO NetworkIO Blank Uptime";
      column_meter_modes_1 = "2 2 2 2 2 2 2";
      fields = with config.lib.htop.fields; [
        PID
        USER
        PRIORITY
        NICE
        M_SIZE
        M_RESIDENT
        M_SHARE
        STATE
        PERCENT_CPU
        PERCENT_MEM
        TIME
        COMM
      ];
      shadow_other_users = 0;
      show_thread_names = 1;
      show_program_path = 0;
      find_comm_in_cmdline = 1;
      strip_exe_from_cmdline = 1;
      show_merged_command = 1;
      header_margin = 1;
      screen_tabs = 1;
      detailed_cpu_time = 0;
      show_cpu_usage = 1;
      show_cpu_frequency = 0;
      show_cpu_temperature = 0;
      degree_fahrenheit = 0;
      update_process_names = 0;
      account_guest_in_cpu_meter = 0;
      hide_function_bar = 0;
      tree_view = 1;
      sort_key = 46;
      tree_sort_key = 0;
      sort_direction = -1;
      tree_sort_direction = 1;
      tree_view_always_by_pid = 1;
      all_branches_collapsed = 0;
    };
  };
}
