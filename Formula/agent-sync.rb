class AgentSync < Formula
  include Language::Python::Shebang

  desc "Sync Claude Code and Codex conversations across machines using Git"
  homepage "https://github.com/HamadaSalhab/agent-sync"
  url "https://github.com/HamadaSalhab/agent-sync/releases/download/v0.1.6/agent-sync-0.1.6.tar.gz"
  sha256 "d35d72668ea2c41e152e94c861c27d494c2a1b6b012da42ed9bb7d78b27dee75"
  license "MIT"

  depends_on "python@3.13"
  uses_from_macos "git"

  def install
    # The application uses only Python's standard library; no pip environment
    # or third-party Python packages are required.
    rewrite_shebang detected_python_shebang, "agent-sync"
    libexec.install "agent-sync", "agent_sync"
    bin.install_symlink libexec/"agent-sync"
    doc.install "README.md", "CHANGELOG.md", "NOTICE.md", "SECURITY.md"
  end

  def caveats
    <<~EOS
      Close Claude Code and Codex before syncing conversations.
      Codex history and title restoration require the Codex CLI.
      Optional encryption requires git-crypt.
      Existing agent-sync configuration and machine identity are reused.
      Large-file snapshots require agent-sync 0.1.6 or newer on every machine.
    EOS
  end

  test do
    ENV["HOME"] = testpath.to_s
    %w[AGENT_SYNC_HOME CLAUDE_DATA_DIR CODEX_HOME].each { |key| ENV.delete(key) }
    assert_match "agent-sync #{version}", shell_output("#{bin}/agent-sync --version")

    remote = testpath/"remote.git"
    system "git", "init", "--bare", remote
    source = testpath/"source-claude/projects/synthetic/session.jsonl"
    source.write "{\"type\":\"user\",\"message\":{\"role\":\"user\",\"content\":\"Synthetic Homebrew test\"}}\n"

    %w[source destination].each do |machine|
      system bin/"agent-sync", "--state-dir", testpath/"#{machine}-state", "init",
             "--remote", remote, "--claude-dir", testpath/"#{machine}-claude",
             "--codex-dir", testpath/"#{machine}-codex", "--tool", "claude"
    end
    system bin/"agent-sync", "--state-dir", testpath/"source-state", "backup", "--tool", "claude"
    system bin/"agent-sync", "--state-dir", testpath/"source-state", "push", "--tool", "claude"
    system bin/"agent-sync", "--state-dir", testpath/"destination-state", "pull", "--tool", "claude"
    assert_equal source.read, (testpath/"destination-claude/projects/synthetic/session.jsonl").read
    assert_equal 1, (testpath/"source-state/backups").glob("*/manifest.json").length
  end
end
