(in-package #:nyxt-user)

(define-command-global play-video-in-mpv ()
  "Extracts the current buffer's URL and opens it directly in mpv."
  (let* ((current-url (quri:render-uri (url (current-buffer)))))
    (if (str:contains? "youtube.com" current-url)
        (progn
          (echo "Launching mpv for: ~a" current-url)
          ;; Use launch-program so we don't freeze the Nyxt UI thread
          (uiop:launch-program (list "mpv" current-url)))
        (echo-warning "Not a YouTube URL. Aborting mpv launch."))))

(define-command-global download-video-yt-dlp ()
  "Downloads the current buffer's URL using yt-dlp inside an Alacritty window."
  (let* ((current-url (quri:render-uri (url (current-buffer)))))
    (if (str:contains? "youtube.com" current-url)
        (progn
          (echo "Spawning yt-dlp download for: ~a" current-url)
          ;; Spawning your terminal to handle the download visually
          (uiop:launch-program (list "alacritty" "-e" "yt-dlp" current-url)))
        (echo-warning "Not a YouTube URL. Aborting download."))))
