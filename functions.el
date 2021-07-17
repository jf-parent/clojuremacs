(require 'cl-lib)

(defun my/new-empty-buffer ()
 (interactive)
 (switch-to-buffer (generate-new-buffer "Untitled")))

(defun my/evil-yank-advice (orig-fn beg end &rest args)
 (pulse-momentary-highlight-region beg end)
 (apply orig-fn beg end args))

(advice-add 'evil-yank :around 'my/evil-yank-advice)

;; Borrowed from Spacemacs
(defun my/switch-to-scratch-buffer (&optional arg)
 "Switch to scratch buffer"
 (interactive "P")
 (switch-to-buffer (get-buffer-create "*scratch*")))

;; Borrowed from Spacemacs
;; https://github.com/syl20bnr/spacemacs/blob/77d84b14e057aadc6a71c536104b57c617600f35/core/core-funcs.el#L342
(defun my/alternate-buffer (&optional window)
 "Switch back and forth between current and last buffer in the
 current window."
 (interactive)
 (cl-destructuring-bind (buf start pos)
  (or (cl-find (window-buffer window) (window-prev-buffers)
       :key #'car :test-not #'eq)
   (list (other-buffer) nil nil))
  (if (not buf)
   (message "Last buffer not found.")
   (set-window-buffer-start-and-point window buf start pos))))
