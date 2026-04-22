-- Ansible filetype detection
-- Sets filetype to `yaml.ansible` so ansible-language-server and ansible-lint activate
vim.filetype.add({
    pattern = {
        [".*/playbooks/.*%.ya?ml"] = "yaml.ansible",
        [".*/roles/.*/tasks/.*%.ya?ml"] = "yaml.ansible",
        [".*/roles/.*/handlers/.*%.ya?ml"] = "yaml.ansible",
        [".*/roles/.*/meta/.*%.ya?ml"] = "yaml.ansible",
        [".*/roles/.*/vars/.*%.ya?ml"] = "yaml.ansible",
        [".*/roles/.*/defaults/.*%.ya?ml"] = "yaml.ansible",
        [".*%.ansible%.ya?ml"] = "yaml.ansible",
        ["playbook%.ya?ml"] = "yaml.ansible",
        ["site%.ya?ml"] = "yaml.ansible",
    },
})
