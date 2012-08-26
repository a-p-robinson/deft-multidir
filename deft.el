;;; deft.el --- quickly browse, filter, and edit plain text notes

;;; Copyright (C) 2011-2012 Jason R. Blevins <jrblevin@sdf.org>
;; All rights reserved.

;; Redistribution and use in source and binary forms, with or without
;; modification, are permitted provided that the following conditions are met:
;; 1. Redistributions of source code must retain the above copyright
;;    notice, this list of conditions and the following disclaimer.
;; 2. Redistributions in binary form must reproduce the above copyright
;;    notice, this list of conditions and the following disclaimer in the
;;    documentation  and/or other materials provided with the distribution.
;; 3. Neither the names of the copyright holders nor the names of any
;;    contributors may be used to endorse or promote products derived from
;;    this software without specific prior written permission.

;; THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
;; AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
;; IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
;; ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
;; LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
;; CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
;; SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
;; INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
;; CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
;; ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
;; POSSIBILITY OF SUCH DAMAGE.

;;; Version: 0.4
;;; Author: Jason R. Blevins <jrblevin@sdf.org>
;;; Keywords: plain text, notes, Simplenote, Notational Velocity
;;; URL: http://jblevins.org/projects/deft/

;; This file is not part of GNU Emacs.

;;; Commentary:

;; Deft is an Emacs mode for quickly browsing, filtering, and editing
;; directories of plain text notes, inspired by Notational Velocity.
;; It was designed for increased productivity when writing and taking
;; notes by making it fast and simple to find the right file at the
;; right time and by automating many of the usual tasks such as
;; creating new files and saving files.

;; Deft is open source software and may be freely distributed and
;; modified under the BSD license.  Version 0.4 is the latest stable
;; version, released on December 11, 2011.  You may download it
;; directly here:

;;   * [deft.el](http://jblevins.org/projects/deft/deft.el)

;; To follow or contribute to Deft development, you can either
;; [browse](http://jblevins.org/git/deft.git) or clone the Git
;; repository:

;;     git clone git://jblevins.org/git/deft.git

;; ![File Browser](http://jblevins.org/projects/deft/browser.png)

;; The Deft buffer is simply a file browser which lists the titles of
;; all text files in the Deft directory followed by short summaries
;; and last modified times.  The title is taken to be the first line
;; of the file and the summary is extracted from the text that
;; follows.  Files are sorted in terms of the last modified date, from
;; newest to oldest.

;; All Deft files or notes are simple plain text files where the first
;; line contains a title.  As an example, the following directory
;; structure generated the screenshot above.
;;
;;     % ls ~/.deft
;;     about.txt    browser.txt     directory.txt   operations.txt
;;     ack.txt      completion.txt  extensions.txt  text-mode.txt
;;     binding.txt  creation.txt    filtering.txt
;;
;;     % cat ~/.deft/about.txt
;;     About
;;
;;     An Emacs mode for slicing and dicing plain text files.

;; ![Filtering](http://jblevins.org/projects/deft/filter.png)

;; Deft's primary operation is searching and filtering.  The list of
;; files can be limited or filtered using a search string, which will
;; match both the title and the body text.  To initiate a filter,
;; simply start typing.  Filtering happens on the fly.  As you type,
;; the file browser is updated to include only files that match the
;; current string.

;; To open the first matching file, simply press `RET`.  If no files
;; match your search string, pressing `RET` will create a new file
;; using the string as the title.  This is a very fast way to start
;; writing new notes.  The filename will be generated automatically.
;; If you prefer to provide a specific filename, use `C-RET` instead.

;; To open files other than the first match, navigate up and down
;; using `C-p` and `C-n` and press `RET` on the file you want to open.

;; Press `C-c C-c` to clear the filter string and display all files
;; and `C-c C-g` to refresh the file browser using the current filter
;; string.

;; By default, Deft filters files in incremental string search mode,
;; where "search string" will match all files containing both "search"
;; and "string" in any order.  Alternatively, Deft supports direct
;; regex filtering.  Pressing `C-c C-t` will toggle between these two
;; modes of operation.  Regex mode is indicated by an "R" in the mode
;; line.

;; Static filtering is also possible by pressing `C-c C-l`.  This is
;; sometimes useful on its own, and it may be preferable in some
;; situations, such as over slow connections or on older systems,
;; where interactive filtering performance is poor.

;; Common file operations can also be carried out from within Deft.
;; Files can be renamed using `C-c C-r` or deleted using `C-c C-d`.
;; New files can also be created using `C-c C-n` for quick creation or
;; `C-c C-m` for a filename prompt.  You can leave Deft at any time
;; with `C-c C-q`.

;; Files opened with deft are automatically saved after Emacs has been
;; idle for a customizable number of seconds.  This value is a floating
;; point number given by `deft-auto-save-interval' (default: 1.0).

;; Getting Started
;; ---------------

;; To start using it, place it somewhere in your Emacs load-path and
;; add the line

;;     (require 'deft)

;; in your `.emacs` file.  Then run `M-x deft` to start.  It is useful
;; to create a global keybinding for the `deft` function (e.g., a
;; function key) to start it quickly (see below for details).

;; When you first run Deft, it will complain that it cannot find the
;; `~/.deft` directory.  You can either create a symbolic link to
;; another directory where you keep your notes or run `M-x deft-setup`
;; to create the `~/.deft` directory automatically.

;; One useful way to use Deft is to keep a directory of notes in a
;; Dropbox folder.  This can be used with other applications and
;; mobile devices, for example, Notational Velocity or Simplenote
;; on OS X, Elements on iOS, or Epistle on Android.

;; Customization
;; -------------

;; Customize the `deft` group to change the functionality.

;; By default, Deft looks for notes by searching for files with the
;; extension `.txt` in the `~/.deft` directory.  You can customize
;; both the file extension and the Deft directory by running
;; `M-x customize-group` and typing `deft`.  Alternatively, you can
;; configure them in your `.emacs` file:

;;     (setq deft-extension "txt")
;;     (setq deft-directory "~/Dropbox/notes")

;; You can also customize the major mode that Deft uses to edit files,
;; either through `M-x customize-group` or by adding something like
;; the following to your `.emacs` file:

;;     (setq deft-text-mode 'markdown-mode)

;; Note that the mode need not be a traditional text mode.  If you
;; prefer to write notes as LaTeX fragments, for example, you could
;; set `deft-extension' to "tex" and `deft-text-mode' to `latex-mode'.

;; If you prefer `org-mode', then simply use

;;     (setq deft-extension "org")
;;     (setq deft-text-mode 'org-mode)

;; For compatibility with other applications which take the title from
;; the filename, rather than from first line of the file, set the
;; `deft-use-filename-as-title' flag to a non-nil value.  This also
;; changes the default behavior for creating new files when the filter
;; is non-empty: the filter string will be used as the new filename
;; rather than inserted into the new file.  To enable this
;; functionality, simply add the following to your `.emacs` file:

;;     (setq deft-use-filename-as-title t)

;; You can easily set up a global keyboard binding for Deft.  For
;; example, to bind it to F8, add the following code to your `.emacs`
;; file:

;;     (global-set-key [f8] 'deft)

;; The faces used for highlighting various parts of the screen can
;; also be customized.  By default, these faces inherit their
;; properties from the standard font-lock faces defined by your current
;; color theme.

;; Incremental string search is the default method of filtering on
;; startup, but you can set `deft-incremental-search' to nil to make
;; regex search the default.

;; The title of each file is taken to be the first line of the file,
;; with certain characters removed from the beginning (hash
;; characters, as used in Markdown headers, and asterisks, as in Org
;; Mode headers).  The substrings to remove are specified in
;; `deft-strip-title-regex'.

;; More generally, the title post-processing function itself can be
;; customized by setting `deft-parse-title-function', which accepts
;; the first line of the file as an argument and returns the parsed
;; title to display in the file browser.  The default function is
;; `deft-strip-title', which removes all occurrences of
;; `deft-strip-title-regex' as described above.

;; Acknowledgments
;; ---------------

;; Thanks to Konstantinos Efstathiou for writing simplnote.el, from
;; which I borrowed liberally, and to Zachary Schneirov for writing
;; Notational Velocity, which I have never had the pleasure of using,
;; but whose functionality and spirit I wanted to bring to other
;; platforms, such as Linux, via Emacs.

;; History
;; -------

;; Version 0.4 (2011-12-11):

;; * Improved filtering performance.
;; * Optionally take title from filename instead of first line of the
;;   contents (see `deft-use-filename-as-title').
;; * Dynamically resize width to fit the entire window.
;; * Customisable time format (see `deft-time-format').
;; * Handle `deft-directory' properly with or without a trailing slash.

;; Version 0.3 (2011-09-11):

;; * Internationalization: support filtering with multibyte characters.

;; Version 0.2 (2011-08-22):

;; * Match filenames when filtering.
;; * Automatically save opened files (optional).
;; * Address some byte-compilation warnings.

;; Deft was originally written by Jason Blevins.
;; The initial version, 0.1, was released on August 6, 2011.

;;; Code:

(require 'widget)

;; Customization

(defgroup deft nil
  "Emacs Deft mode."
  :group 'local)

(defcustom deft-directories (list (expand-file-name "~/.deft/"))
  "Deft directory."
  :type '(list directory)
  :safe 'stringp
  :group 'deft)

(defcustom deft-extension "txt"
  "Deft file extension."
  :type 'string
  :safe 'stringp
  :group 'deft)

(defcustom deft-text-mode 'text-mode
  "Default mode used for editing files."
  :type 'function
  :group 'deft)

(defcustom deft-auto-save-interval 1.0
  "Idle time in seconds before automatically saving buffers opened by Deft.
Set to zero to disable."
  :type 'float
  :group 'deft)

(defcustom deft-time-format " %Y-%m-%d %H:%M"
  "Format string for modification times in the Deft browser.
Set to nil to hide."
  :type '(choice (string :tag "Time format")
		 (const :tag "Hide" nil))
  :group 'deft)

(defcustom deft-use-filename-as-title nil
  "Use filename as title, instead of the first line of the contents."
  :type 'boolean
  :group 'deft)

(defcustom deft-incremental-search t
  "Use incremental string search when non-nil and regex search when nil.
During incremental string search, substrings separated by spaces are
treated as subfilters, each of which must match a file.  They need
not be adjacent and may appear in any order.  During regex search, the
entire filter string is interpreted as a single regular expression."
  :type 'boolean
  :group 'deft)

(defcustom deft-parse-title-function 'deft-strip-title
  "Function for post-processing file titles."
  :type 'function
  :group 'deft)

(defcustom deft-strip-title-regex "^[#\* ]*"
  "Regular expression to remove from file titles."
  :type 'regexp
  :safe 'stringp
  :group 'deft)

;; Faces

(defgroup deft-faces nil
  "Faces used in Deft mode"
  :group 'deft
  :group 'faces)

(defface deft-header-face
  '((t :inherit font-lock-keyword-face :bold t))
  "Face for Deft header."
  :group 'deft-faces)

(defface deft-directory-face
  '((t :inherit font-lock-keyword-face :underline t))
  "Face for a directory."
  :group 'deft-faces)

(defface deft-filter-string-face
  '((t :inherit font-lock-string-face))
  "Face for Deft filter string."
  :group 'deft-faces)

(defface deft-title-face
  '((t :inherit font-lock-function-name-face :bold t))
  "Face for Deft file titles."
  :group 'deft-faces)

(defface deft-separator-face
  '((t :inherit font-lock-comment-delimiter-face))
  "Face for Deft separator string."
  :group 'deft-faces)

(defface deft-summary-face
  '((t :inherit font-lock-comment-face))
  "Face for Deft file summary strings."
  :group 'deft-faces)

(defface deft-time-face
  '((t :inherit font-lock-variable-name-face))
  "Face for Deft last modified times."
  :group 'deft-faces)

;; Constants

(defconst deft-version "0.4")

(defconst deft-buffer "*Deft*"
  "Deft buffer name.")

(defconst deft-separator " --- "
  "Text used to separate file titles and summaries.")

;; Global variables

(defvar deft-mode-hook nil
  "Hook run when entering Deft mode.")

(defvar deft-filter-regexp nil
  "Current filter regexp used by Deft.")

(defvar deft-current-files nil
  "List of files matching current filter.")

(defvar deft-all-files nil
  "List of files matching current filter.")

(defvar deft-hash-contents nil
  "Hash containing complete cached file contents, keyed by filename.")

(defvar deft-hash-mtimes nil
  "Hash containing cached file modification times, keyed by filename.")

(defvar deft-hash-titles nil
  "Hash containing cached file titles, keyed by filename.")

(defvar deft-hash-summaries nil
  "Hash containing cached file summaries, keyed by filename.")

(defvar deft-auto-save-buffers nil
  "List of buffers that will be automatically saved.")

(defvar deft-window-width nil
  "Width of Deft buffer.")

;; Helpers

(defun deft-whole-filter-regexp ()
  "Join incremental filters into one."
  (mapconcat 'identity (reverse deft-filter-regexp) " "))

(defun deft-search-forward (str)
  "Function to use when matching files against filter strings.
This function calls `search-forward' when `deft-incremental-search'
is non-nil and `re-search-forward' otherwise."
  (if deft-incremental-search
      (search-forward str nil t)
    (re-search-forward str nil t)))

(defun deft-set-mode-name ()
  (if deft-incremental-search
      (setq mode-name "Deft")
    (setq mode-name "Deft/R")))

(defun deft-toggle-incremental-search ()
  "Toggle the `deft-incremental-search' setting."
  (interactive)
  (cond
   (deft-incremental-search
    (setq deft-incremental-search nil)
    (message "Regex search"))
   (t
    (setq deft-incremental-search t)
    (message "Incremental string search")))
  (deft-filter (deft-whole-filter-regexp) t)
  (deft-set-mode-name))

;; File processing

(defun deft-chomp (str)
  "Trim leading and trailing whitespace from STR."
  (let ((s str))
    (replace-regexp-in-string "\\(^[[:space:]\n]*\\|[[:space:]\n]*$\\)" "" s)))

(defun deft-base-filename (file)
  "Strip the path and extension from filename FILE."
  (setq file (file-name-nondirectory file))
  (if (> (length deft-extension) 0)
      (setq file (replace-regexp-in-string (concat "\." deft-extension "$") "" file)))
  file)

(defun deft-find-all-files ()
  "Return a list of all files in the Deft directory."
  (if (file-exists-p deft-directory)
      (let (files result)
        ;; List all files
        (setq files
              (directory-files deft-directory t
                               (concat "\." deft-extension "$") t))
        ;; Filter out files that are not readable or are directories
        (dolist (file files)
          (when (and (file-readable-p file)
                     (not (file-directory-p file)))
            (setq result (cons file result))))
        result)))

(defun deft-strip-title (title)
  "Remove all strings matching `deft-strip-title-regex' from TITLE."
  (replace-regexp-in-string deft-strip-title-regex "" title))

(defun deft-parse-title (file contents)
  "Parse the given FILE and CONTENTS and determine the title.
According to `deft-use-filename-as-title', the title is taken to
be the first non-empty line of a file or the file name."
  (if deft-use-filename-as-title
      (deft-base-filename file)
    (let ((begin (string-match "^.+$" contents)))
      (if begin
          (funcall deft-parse-title-function
                   (substring contents begin (match-end 0)))
        (deft-base-filename file)))))

(defun deft-parse-summary (contents title)
  "Parse the file CONTENTS, given the TITLE, and extract a summary.
The summary is a string extracted from the contents following the
title."
  (let ((summary (replace-regexp-in-string "[\n\t]" " " contents)))
    (if (and (not deft-use-filename-as-title) title)
        (if (string-match (regexp-quote title) summary)
            (deft-chomp (substring summary (match-end 0) nil))
          "")
      summary)))

(defun deft-cache-file (file)
  "Update file cache if FILE exists."
  (when (file-exists-p file)
    (let ((mtime-cache (deft-file-mtime file))
          (mtime-file (nth 5 (file-attributes file))))
      (if (or (not mtime-cache)
              (time-less-p mtime-cache mtime-file))
          (deft-cache-newer-file file mtime-file)))))

(defun deft-cache-newer-file (file mtime)
  "Update cached information for FILE with given MTIME."
  ;; Modification time
  (puthash file mtime deft-hash-mtimes)
  (let (contents title)
    ;; Contents
    (with-current-buffer (get-buffer-create "*Deft temp*")
      (insert-file-contents file nil nil nil t)
      (setq contents (concat (buffer-string))))
    (puthash file contents deft-hash-contents)
    ;; Title
    (setq title (deft-parse-title file contents))
    (puthash file title deft-hash-titles)
    ;; Summary
    (puthash file (deft-parse-summary contents title) deft-hash-summaries))
  (kill-buffer "*Deft temp*"))

(defun deft-file-newer-p (file1 file2)
  "Return non-nil if FILE1 was modified since FILE2 and nil otherwise."
  (let (time1 time2)
    (setq time1 (deft-file-mtime file1))
    (setq time2 (deft-file-mtime file2))
    (time-less-p time2 time1)))

(defun deft-cache-initialize ()
  "Initialize hash tables for caching files."
  (setq deft-hash-contents (make-hash-table :test 'equal))
  (setq deft-hash-mtimes (make-hash-table :test 'equal))
  (setq deft-hash-titles (make-hash-table :test 'equal))
  (setq deft-hash-summaries (make-hash-table :test 'equal)))

(defun deft-cache-update-all ()
  "Update file list and update cached information for each file."
  (setq deft-all-files (deft-find-all-files))             ; List all files
  (mapc 'deft-cache-file deft-all-files)                  ; Cache contents
  (setq deft-all-files (deft-sort-files deft-all-files))) ; Sort by mtime

(defun deft-cache-update-file (file)
  "Update cached information for a single file."
  (deft-cache-file file)                                  ; Cache contents
  (setq deft-all-files (deft-sort-files deft-all-files))) ; Sort by mtime

;; Cache access

(defun deft-file-contents (file)
  "Retrieve complete contents of FILE from cache."
  (gethash file deft-hash-contents))

(defun deft-file-mtime (file)
  "Retrieve modified time of FILE from cache."
  (gethash file deft-hash-mtimes))

(defun deft-file-title (file)
  "Retrieve title of FILE from cache."
  (gethash file deft-hash-titles))

(defun deft-file-summary (file)
  "Retrieve summary of FILE from cache."
  (gethash file deft-hash-summaries))

;; File list display

(defun deft-print-header ()
  "Prints the *Deft* buffer header."
  (if deft-filter-regexp
      (progn
        (widget-insert
         (propertize "Deft: " 'face 'deft-header-face))
        (widget-insert
         (propertize (deft-whole-filter-regexp) 'face 'deft-filter-string-face)))
    (widget-insert
         (propertize "Deft" 'face 'deft-header-face)))
  (widget-insert "\n\n"))

(defun deft-buffer-files-setup ()
  "Render the directories and files in the *Deft* buffer."
  (if (null deft-directories))
      (widget-insert (deft-no-directory-message))
    (if deft-current-files
        (mapc 'deft-directory-or-files-widget deft-current-files)
      (widget-insert (deft-no-files-message))))

(defun deft-buffer-setup ()
  "Render the file browser in the *Deft* buffer."
  (setq deft-window-width (window-width))
  (let ((inhibit-read-only t))
    (erase-buffer))
  (remove-overlays)
  (deft-print-header)

  ;; Print the files list
  (deft-buffer-files-setup)

  (use-local-map deft-mode-map)
  (widget-setup)
  (goto-char 1)
  (forward-line 2))

(defun deft-directory-or-files-widget (dir-or-files)
  "Call either to `deft-directory-widget' or `deft-file-widget' (for each file) depending on the input argument. If a string, the name of a directory is assumed. If a list, a list of files inside a directory is assumed."
  (if (listp dir-or-files)
   ;; lists, even empty, are assumed to be a list of files
      (mapc 'deft-file-widget dir-or-files)
    ;; if not a list, a directory is assumed
    (deft-directory-widget dir-or-files)))

(defun deft-directory-widget (directory)
  "Add a line to the file browser for the given DIRECTORY."
  (widget-insert (propertize deft-directory 'face 'deft-directory-face))
  (widget-insert ":\n")
)

(defun deft-file-widget (file)
  "Add a line to the file browser for the given FILE."
  (when file
    (let* ((key (file-name-nondirectory file))
	   (text (deft-file-contents file))
	   (title (deft-file-title file))
	   (summary (deft-file-summary file))
	   (mtime (when deft-time-format
		    (format-time-string deft-time-format (deft-file-mtime file))))
	   (mtime-width (length mtime))
	   (line-width (- deft-window-width mtime-width))
	   (title-width (min line-width (length title)))
	   (summary-width (min (length summary)
			       (- line-width
				  title-width
				  (length deft-separator)))))
      (widget-create 'link
                     :button-prefix ""
                     :button-suffix ""
                     :button-face 'deft-title-face
                     :format "%[%v%]"
                     :tag file
                     :help-echo "Edit this file"
                     :notify (lambda (widget &rest ignore)
                               (deft-open-file (widget-get widget :tag)))
                     (if title (substring title 0 title-width) "[Empty file]"))
      (when (> summary-width 0)
        (widget-insert (propertize deft-separator 'face 'deft-separator-face))
        (widget-insert (propertize (substring summary 0 summary-width)
				   'face 'deft-summary-face)))
      (when mtime
	(while (< (current-column) line-width)
	  (widget-insert " "))
	(widget-insert (propertize mtime 'face 'deft-time-face)))
      (widget-insert "\n"))))

(add-hook 'window-configuration-change-hook
	  (lambda ()
	    (when (and (eq (current-buffer) (get-buffer deft-buffer))
                       (not (eq deft-window-width (window-width))))
              (deft-buffer-setup))))

(defun deft-refresh ()
  "Update the file cache, reapply the filter, and refresh the *Deft* buffer."
  (interactive)
  (deft-cache-update-all)
  (deft-refresh-filter))

(defun deft-refresh-filter ()
  "Reapply the filter and refresh the *Deft* buffer.
Call this after any actions which update the cache."
  (interactive)
  (deft-filter-update)
  (deft-refresh-browser))

(defun deft-refresh-browser ()
  "Refresh the *Deft* buffer in the background.
Call this function after any actions which update the filter and file list."
  (when (get-buffer deft-buffer)
    (with-current-buffer deft-buffer
      (deft-buffer-setup))))

(defun deft-no-directory-message ()
  "Return a short message to display when the Deft directory does not exist."
  (concat "Directory " deft-directory " does not exist.\n"))

(defun deft-no-files-message ()
  "Return a short message to display if no files are found."
  (if deft-filter-regexp
      "No files match the current filter string.\n"
    "No files found."))

;; File list file management actions

(defun deft-open-file (file)
  "Open FILE in a new buffer and setting its mode."
  (prog1 (find-file file)
    (funcall deft-text-mode)
    (add-to-list 'deft-auto-save-buffers (buffer-name))
    (add-hook 'after-save-hook
              (lambda () (save-excursion
                           (deft-cache-update-file buffer-file-name)
                           (deft-refresh-filter)))
              nil t)))

(defun deft-find-file (file)
  "Find FILE interactively using the minibuffer."
  (interactive "F")
  (deft-open-file file))

(defun deft-new-file-named (file)
  "Create a new file named FILE (or interactively prompt for a filename).
If the filter string is non-nil and title is not from file name,
use it as the title."
  (interactive "sNew filename (without extension): ")
  (setq file (concat (file-name-as-directory deft-directory)
                     file "." deft-extension))
  (if (file-exists-p file)
      (message (concat "Aborting, file already exists: " file))
    (when (and deft-filter-regexp (not deft-use-filename-as-title))
      (write-region (deft-whole-filter-regexp) nil file nil))
    (deft-open-file file)))

;;;###autoload
(defun deft-new-file ()
  "Create a new file quickly, with an automatically generated filename
or the filter string if non-nil and deft-use-filename-as-title is set.
If the filter string is non-nil and title is not from filename,
use it as the title."
  (interactive)
  (let (filename)
    (if (and deft-use-filename-as-title deft-filter-regexp)
	(setq filename (concat (file-name-as-directory deft-directory) (deft-whole-filter-regexp) "." deft-extension))
      (let (fmt counter temp-buffer)
	(setq counter 0)
	(setq fmt (concat "deft-%d." deft-extension))
	(setq filename (concat (file-name-as-directory deft-directory)
			       (format fmt counter)))
	(while (or (file-exists-p filename)
		   (get-file-buffer filename))
	  (setq counter (1+ counter))
	  (setq filename (concat (file-name-as-directory deft-directory)
				 (format fmt counter))))
	(when deft-filter-regexp
	  (write-region (concat (deft-whole-filter-regexp) "\n\n") nil filename nil))))
    (deft-open-file filename)
    (with-current-buffer (get-file-buffer filename)
      (goto-char (point-max)))))

(defun deft-delete-file ()
  "Delete the file represented by the widget at the point.
If the point is not on a file widget, do nothing.  Prompts before
proceeding."
  (interactive)
  (let ((filename (widget-get (widget-at) :tag)))
    (when filename
      (when (y-or-n-p
             (concat "Delete file " (file-name-nondirectory filename) "? "))
        (delete-file filename)
        (delq filename deft-current-files)
        (delq filename deft-all-files)
        (deft-refresh)))))

(defun deft-rename-file ()
  "Rename the file represented by the widget at the point.
If the point is not on a file widget, do nothing."
  (interactive)
  (let (old-filename new-filename old-name new-name)
    (setq old-filename (widget-get (widget-at) :tag))
    (when old-filename
      (setq old-name (deft-base-filename old-filename))
      (setq new-name (read-string
                      (concat "Rename " old-name " to (without extension): ")))
      (setq new-filename
            (concat (file-name-as-directory deft-directory)
                    new-name "." deft-extension))
      (rename-file old-filename new-filename)
      (deft-refresh))))

;; File list filtering

(defun deft-sort-files (files)
  "Sort FILES in reverse order by modified time."
  (sort files (lambda (f1 f2) (deft-file-newer-p f1 f2))))

(defun deft-filter-initialize ()
  "Initialize the filter string (nil) and files list (all files)."
  (interactive)
  (setq deft-filter-regexp nil)
  (setq deft-current-files deft-all-files))

(defun deft-filter-update ()
  "Update the filtered files list using the current filter regexp."
  (if (not deft-filter-regexp)
      (setq deft-current-files deft-all-files)
    (setq deft-current-files (mapcar (lambda (file)
				       (deft-filter-match-file file t))
				     deft-all-files))
    (setq deft-current-files (delq nil deft-current-files))))

(defun deft-filter-match-file (file &optional batch)
  "Return FILE if FILE matches the current filter regexp."
  (with-temp-buffer
    (insert file)
    (insert (deft-file-title file))
    (insert (deft-file-contents file))
    (if batch
	(if (every (lambda (filter)
		     (goto-char (point-min))
                     (deft-search-forward filter))
		   deft-filter-regexp)
	    file)
      (goto-char (point-min))
      (if (deft-search-forward (car deft-filter-regexp))
	  file))))

;; Filters that cause a refresh

(defun deft-filter-clear ()
  "Clear the current filter string and refresh the file browser."
  (interactive)
  (when deft-filter-regexp
    (setq deft-filter-regexp nil)
    (setq deft-current-files deft-all-files)
    (deft-refresh))
  (message "Filter cleared."))

(defun deft-filter (str &optional reset)
  "Update the filter string with STR and update the file browser.
In incremental search mode, STR will be added to the list of
filter strings.  If STR has zero length, one element is removed
from the list.  In regex search mode, the current filter string
will be replaced with STR.  When called interactively, or when
RESET is non-nil, always replace the entire filter string."
  (interactive "sFilter: ")
  (if deft-incremental-search
      (if (or (called-interactively-p 'any) reset)
          (if (= (length str) 0)
              (setq deft-filter-regexp nil)
            (setq deft-filter-regexp (reverse (split-string str " "))))
        (if str
            (setcar deft-filter-regexp str)
          (setq deft-filter-regexp (cdr deft-filter-regexp))))
    (setq deft-filter-regexp (list str)))
  (deft-filter-update)
  (deft-refresh-browser))

(defun deft-filter-increment ()
  "Append character to the filter regexp and update `deft-current-files'."
  (interactive)
  (let ((char last-command-event))
    (if (= char ?\S-\ )
	(setq char ?\s))
    (setq char (char-to-string char))
    (if (and deft-incremental-search (string= char " "))
	(setq deft-filter-regexp (cons "" deft-filter-regexp))
      (progn
	(if (car deft-filter-regexp)
	    (setcar deft-filter-regexp (concat (car deft-filter-regexp) char))
	  (setq deft-filter-regexp (list char)))
	(setq deft-current-files (mapcar 'deft-filter-match-file deft-current-files))
	(setq deft-current-files (delq nil deft-current-files))
	(deft-refresh-browser)))))

(defun deft-filter-decrement ()
  "Remove last character from the filter regexp and update `deft-current-files'."
  (interactive)
  (cond ((> (length (car deft-filter-regexp)) 0)
	 (deft-filter (substring (car deft-filter-regexp) 0 -1)))
	((> (length deft-filter-regexp) 1)
	 (deft-filter nil))
	(t (deft-filter-clear))))

(defun deft-complete ()
  "Complete the current action.
If there is a widget at the point, press it.  If a filter is
applied and there is at least one match, open the first matching
file.  If there is an active filter but there are no matches,
quick create a new file using the filter string as the title.
Otherwise, quick create a new file."
  (interactive)
  (cond
   ;; Activate widget
   ((widget-at)
    (widget-button-press (point)))
   ;; Active filter string with match
   ((and deft-filter-regexp deft-current-files)
    (deft-open-file (car deft-current-files)))
   ;; Default
   (t
    (deft-new-file))))

;;; Automatic File Saving

(defun deft-auto-save ()
  (save-excursion
    (dolist (buf deft-auto-save-buffers)
      (if (get-buffer buf)
          ;; Save open buffers that have been modified.
          (progn
            (set-buffer buf)
            (when (buffer-modified-p)
              (basic-save-buffer)))
        ;; If a buffer is no longer open, remove it from auto save list.
        (delq buf deft-auto-save-buffers)))))

;;; Mode definition

(defun deft-show-version ()
  "Show the version number in the minibuffer."
  (interactive)
  (message "Deft %s" deft-version))

(defun deft-setup ()
  "Prepare environment by creating the Deft notes directory."
  (interactive)
  (when (not (file-exists-p deft-directory))
    (make-directory deft-directory t))
  (deft-refresh))

(defvar deft-mode-map
  (let ((i 0)
        (map (make-keymap)))
    ;; Make multibyte characters extend the filter string.
    (set-char-table-range (nth 1 map) (cons #x100 (max-char))
                          'deft-filter-increment)
    ;; Extend the filter string by default.
    (setq i ?\s)
    (while (< i 256)
      (define-key map (vector i) 'deft-filter-increment)
      (setq i (1+ i)))
    ;; Handle backspace and delete
    (define-key map (kbd "DEL") 'deft-filter-decrement)
    ;; Handle return via completion or opening file
    (define-key map (kbd "RET") 'deft-complete)
    ;; Filtering
    (define-key map (kbd "C-c C-l") 'deft-filter)
    (define-key map (kbd "C-c C-c") 'deft-filter-clear)
    ;; File creation
    (define-key map (kbd "C-c C-n") 'deft-new-file)
    (define-key map (kbd "C-c C-m") 'deft-new-file-named)
    (define-key map (kbd "<C-return>") 'deft-new-file-named)
    ;; File management
    (define-key map (kbd "C-c C-d") 'deft-delete-file)
    (define-key map (kbd "C-c C-r") 'deft-rename-file)
    (define-key map (kbd "C-c C-f") 'deft-find-file)
    ;; Settings
    (define-key map (kbd "C-c C-t") 'deft-toggle-incremental-search)
    ;; Miscellaneous
    (define-key map (kbd "C-c C-g") 'deft-refresh)
    (define-key map (kbd "C-c C-q") 'quit-window)
    ;; Widgets
    (define-key map [down-mouse-1] 'widget-button-click)
    (define-key map [down-mouse-2] 'widget-button-click)
    (define-key map (kbd "<tab>") 'widget-forward)
    (define-key map (kbd "<backtab>") 'widget-backward)
    (define-key map (kbd "<S-tab>") 'widget-backward)
    map)
  "Keymap for Deft mode.")

(defun deft-mode ()
  "Major mode for quickly browsing, filtering, and editing plain text notes.
Turning on `deft-mode' runs the hook `deft-mode-hook'.

\\{deft-mode-map}."
  (kill-all-local-variables)
  (setq truncate-lines t)
  (setq buffer-read-only t)
  (setq default-directory deft-directory)
  (use-local-map deft-mode-map)
  (deft-cache-initialize)
  (deft-cache-update-all)
  (deft-filter-initialize)
  (setq major-mode 'deft-mode)
  (deft-set-mode-name)
  (deft-buffer-setup)
  (when (> deft-auto-save-interval 0)
    (run-with-idle-timer deft-auto-save-interval t 'deft-auto-save))
  (run-mode-hooks 'deft-mode-hook))

(put 'deft-mode 'mode-class 'special)

;;;###autoload
(defun deft ()
  "Switch to *Deft* buffer and load files."
  (interactive)
  (switch-to-buffer deft-buffer)
  (if (not (eq major-mode 'deft-mode))
      (deft-mode)))

(provide 'deft)

;;; deft.el ends here
