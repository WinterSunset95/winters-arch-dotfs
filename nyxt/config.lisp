(in-package #:nyxt-user)

(load (uiop:xdg-config-home "nyxt" "youtube.lisp"))

;; Ditch CUA, embrace Emacs bindings for navigation
(define-configuration buffer
  ((default-modes (pushnew 'nyxt/mode/emacs:emacs-mode %slot-value%))))

;; Enable blocker-mode for all web buffers
(define-configuration web-buffer
  ((default-modes (append '(nyxt/mode/blocker:blocker-mode) %slot-default%))))

(define-configuration nyxt/mode/emacs:emacs-mode
  ((keyscheme-map
    (keymap:modify-keyscheme (super)
      "emacs"
      "C-c y p" 'play-video-in-mpv
      "C-c y d" 'download-video-yt-dlp))))

