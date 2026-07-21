{ config, pkgs, ... }: {
  programs.neomutt.enable = true;
  programs.mbsync.enable = true;
  programs.msmtp.enable = true;

  services.imapnotify.enable = true;

  accounts.email.accounts = { 
    wintersunset95 = {
      primary = true;
      address = "wintersunset95@gmail.com";
      userName = "wintersunset95@gmail.com";
      realName = "Mark L F Tlau";

      passwordCommand = "pass Email/wintersunset95";

      imap.host = "imap.gmail.com";
      smtp.host = "smtp.gmail.com";

      mbsync = {
        enable = true;
        create = "both";
        expunge = "both";
      };

      msmtp.enable = true;
      neomutt.enable = true;

      imapnotify = {
        enable = true;
        boxes = [ "Inbox" ];
        onNotify = "${pkgs.isync}/bin/mbsync wintersunset95";
        onNotifyPost = "${pkgs.libnotify}/bin/notify-send 'New Email: wintersunset95@gmail.com' 'Check Neomutt.'";
      };
    };
    wallacethiago095 = {
      address = "wallacethiago095@gmail.com";
      userName = "wallacethiago095@gmail.com";
      realName = "Wallace Thiago";

      passwordCommand = "pass Email/wallacethiago095";

      imap.host = "imap.gmail.com";
      smtp.host = "smtp.gmail.com";

      mbsync = {
        enable = true;
        create = "both";
        expunge = "both";
      };

      msmtp.enable = true;
      neomutt.enable = true;

      imapnotify = {
        enable = true;
        boxes = [ "Inbox" ];
        onNotify = "${pkgs.isync}/bin/mbsync wallacethiago095";
        onNotifyPost = "${pkgs.libnotify}/bin/notify-send 'New Email: wallacethiago095@gmail.com' 'Check Neomutt.'";
      };
    };
  };
}
