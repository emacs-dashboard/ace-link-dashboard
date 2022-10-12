;;; ace-link-dashboard.el -- Ace link for dashboard-mode
;;; Commentary:
;;; Code:

(require 'avy)
(require 'wid-edit)

;;;###autoload
(defun ace-link-dashboard ()
  "Open a visible link in a `dashboard-mode' buffer."
  (interactive)
  (let ((pt (avy-with 'ace-link-dashboard
              (avy-process
               (mapcar #'cdr (ace-link--dashboard-collect))
               (avy--style-fn avy-style)))))
    (ace-link--dashboard-action pt)))

;;;###autoload
(defun ace-link-dashboard-remove ()
  "Call remove action on widget."
  (interactive)
  (let ((point (avy-with 'ace-link-dashboard-remove
                 (avy-process
                  (mapcar #'cdr (ace-link--dashboard-collect))
                  (avy--style-fn avy-style)))))
    (ace-link--dashboard-remove point)))

(defun ace-link--dashboard-action (point)
  "Call action at POINT when widget is selected."
  (funcall 'widget-button-press point))

(defun ace-link--dashboard-remove (point)
  "Call remove action on item at POINT."
  (dashboard-remove-item-under))

(defun ace-link--dashboard-collect ()
  "Collect all widgets in the current `dashboard-mode' buffer."
  (save-excursion
    (let ((previous-point (window-start))
          (end (window-end))
          (candidates nil)
          (next-widget-point (lambda ()
                               (progn (widget-move 1)
                                      (point)))))
      (goto-char (window-start))
      (while (< previous-point (funcall next-widget-point))
        (setq previous-point (point))
        (push (cons (widget-at previous-point) previous-point) candidates))
      (nreverse candidates))))

(provide 'ace-link-dashboard)
;;; ace-link-dashboard.el ends here
