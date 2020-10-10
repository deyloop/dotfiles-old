;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-


;; Personal Identifiacation
(setq user-full-name "Anurup Dey"
      user-mail-address "anu.rup.dey98@gmail.com")

(set-email-account! "gmail-personal"
                    '((mu4e-sent-folder       . "/gmail-personal/Sent Mail")
                      (mu4e-drafts-folder     . "/gmail-personal/Drafts")
                      (mu4e-trash-folder      . "/gmail-personal/Trash")
                      (mu4e-refile-folder     . "/gmail-personal/All Mail")
                      (smtpmail-smtp-user     . "anu.rup.dey98@gmail.com")
                      (mu4e-compose-signature . "---\nAnurup Dey"))
                    t)

;; Theming and Styling

(setq fancy-splash-image "~/.config/doom/black-hole.png")

(setq doom-font (font-spec :family "Hack" :width 'condensed :size 14 :weight 'semi-light)
      doom-variable-pitch-font (font-spec :family "sans" :size 13))

(setq doom-theme 'doom-spacegrey)

(after! treemacs doom-theme
  (setq doom-themes-treemacs-theme "Default")
  (doom-themes-treemacs-config)
  (treemacs-resize-icons 13))

(use-package! treemacs-icons-dired
  :after treemacs dired
  :config (treemacs-icons-dired-mode))

(use-package! all-the-icons
  :config (setq all-the-icons-scale-factor 1.0))

(custom-set-faces
 '(default ((t (:background "#121212"))))
 '(hl-line ((t (:background "#4D3128")))))

(setq display-line-numbers-type nil)

;; plugin configuration
(use-package! org
  :init (setq org-directory "~/org/"
              org-hide-emphasis-markers t))

(use-package! dap-cpptools
  :defer t
  :hook ((c-mode c++-mode objc-mode cuda-mode) .
         (lambda () (require 'dap-cpptools) (lsp)))
  :config
  (add-hook! 'dap-stopped-hook
    (lambda (_) (call-interactively #'dap-hydra)))
  (setq dap-auto-configure-features '(sessions locals tooltip))
  (setq gc-cons-threshold (* 100 1024 1024)
        read-process-output-max (* 1024 1024)
        treemacs-space-between-root-nodes nil
        company-idle-delay 0.0
        company-minimum-prefix-length 1)
  (map! :leader
        :desc "Toggle Breakpoint"
        "c b" #'dap-breakpoint-toggle))

(after! company
  (setq company-minimum-prefix-length 4))

;; colors each point (cursor) visible as a different color
;; usefull when colaboratively editing
(load! "colorful-points.el")

;; Editor configuration

;; automatically save buffers associated with files on buffer switch
;; and on windows switch
(defadvice switch-to-buffer (before save-buffer-now activate)
  (when buffer-file-name (save-buffer)))
(defadvice other-window (before other-window-now activate)
  (when buffer-file-name (save-buffer)))
(defadvice windmove-up (before other-window-now activate)
  (when buffer-file-name (save-buffer)))
(defadvice windmove-down (before other-window-now activate)
  (when buffer-file-name (save-buffer)))
(defadvice windmove-left (before other-window-now activate)
  (when buffer-file-name (save-buffer)))
(defadvice windmove-right (before other-window-now activate)
  (when buffer-file-name (save-buffer)))

;; Switch to the new window after splitting
(setq evil-split-window-below t
      evil-vsplit-window-right t)



;; 1. What am I?
;; 2. What is this in front of me?
;; 3. What is the relation between me and what is in front of me?
