# Update Strategy for spec-kit-auggie

## 🎯 **Repository Structure**

### **Our Repository:**
- **Origin**: `j0209/spec-kit-auggie` (our enhanced fork)
- **Purpose**: Spec-Kit with AUGGIE integration + community improvements

### **Upstream Sources:**
- **upstream**: `github/spec-kit` (official source)
- **community**: `hungthai1401/spec-kit` (community improvements)

## 🔄 **Update Workflow**

### **1. Regular Updates from Official Repo**
```bash
# Fetch latest from official repo
git fetch upstream

# Check what's new
git log HEAD..upstream/main --oneline

# Merge official updates (preferred method)
git merge upstream/main

# Alternative: Rebase our changes on top
git rebase upstream/main
```

### **2. Cherry-Pick Community Improvements**
```bash
# Fetch from community fork
git fetch community

# Check for useful improvements
git log HEAD..community/main --oneline

# Cherry-pick specific improvements
git cherry-pick <commit-hash>
```

### **3. Handle Conflicts**
When merging/cherry-picking, conflicts may occur in:
- `src/specify_cli/__init__.py` (our AUGGIE integration)
- `pyproject.toml` (version numbers)
- Documentation files

**Resolution Strategy:**
1. **Always preserve AUGGIE integration**
2. **Take their infrastructure improvements**
3. **Merge documentation carefully**

## 📋 **What We Maintain**

### **Our Unique Features (Never Lose These):**
- ✅ AUGGIE CLI support in `AI_CHOICES`
- ✅ AUGGIE tool checking and installation
- ✅ AUGGIE command templates (`templates/commands/auggie/`)
- ✅ Shell integration (`templates/auggie-commands.sh`)
- ✅ Enhanced export with multi-agent orchestration
- ✅ Native AUGGIE task format generation
- ✅ Professional documentation (`docs/`)

### **What We Adopt from Upstream:**
- ✅ Infrastructure improvements (SSL, error handling)
- ✅ Bug fixes and security updates
- ✅ New features that don't conflict with AUGGIE
- ✅ Performance improvements

## 🚨 **Conflict Resolution Guide**

### **Common Conflict Scenarios:**

#### **1. AI_CHOICES Dictionary**
```python
# ALWAYS keep our version:
AI_CHOICES = {
    "copilot": "GitHub Copilot",
    "claude": "Claude Code", 
    "gemini": "Gemini CLI",
    "auggie": "Augment AUGGIE CLI"  # ← NEVER remove this
}
```

#### **2. Tool Checking Functions**
```python
# ALWAYS include AUGGIE checks:
elif selected_ai == "auggie":
    if not check_tool("auggie", "Install with: npm install -g @augmentcode/auggie"):
        console.print("[red]Error:[/red] AUGGIE CLI is required for Augment projects")
        agent_tool_missing = True
```

#### **3. Help Text and Documentation**
- Always include AUGGIE in help text
- Always mention 4 AI assistants (not 3)
- Always include AUGGIE examples
- Keep README.md as our AUGGIE-enhanced version (original preserved as README-ORIGINAL.md)

## 🔍 **Monitoring Strategy**

### **Watch for Updates:**
1. **GitHub Notifications**: Watch both upstream repos
2. **Regular Checks**: Monthly fetch and review
3. **Community PRs**: Monitor for useful improvements

### **Update Frequency:**
- **Official Updates**: Merge immediately (after testing)
- **Community Updates**: Cherry-pick useful ones quarterly
- **Security Updates**: Apply immediately

## 🧪 **Testing Strategy**

### **Before Pushing Updates:**
```bash
# Test basic functionality
python -c "from src.specify_cli import main; main()" check

# Test AUGGIE integration
python -c "from src.specify_cli import main; main()" init test-project --ai auggie --here

# Verify templates exist
ls templates/commands/auggie/
```

### **Integration Tests:**
1. ✅ All 4 AI assistants selectable
2. ✅ AUGGIE tool checking works
3. ✅ AUGGIE templates accessible
4. ✅ Shell integration functional

## 📈 **Long-term Strategy**

### **Goals:**
1. **Stay Current**: Always have latest official improvements
2. **Stay Enhanced**: Maintain our AUGGIE integration advantage
3. **Stay Stable**: Thorough testing before releases
4. **Stay Documented**: Keep our documentation current

### **Contribution Strategy:**
- **We DON'T contribute AUGGIE integration upstream** (keep competitive advantage)
- **We MAY contribute generic improvements** (bug fixes, documentation)
- **We DO benefit from all upstream improvements**

## 🎯 **Success Metrics**

### **Repository Health:**
- ✅ Always builds and runs
- ✅ All tests pass
- ✅ AUGGIE integration intact
- ✅ Documentation current
- ✅ No more than 1 month behind upstream

### **Feature Completeness:**
- ✅ All official Spec-Kit features
- ✅ All useful community improvements
- ✅ Full AUGGIE integration
- ✅ Professional documentation
- ✅ Sustainable update process

---

**This strategy ensures we get the best of all worlds while maintaining our competitive advantage with AUGGIE integration!** 🚀
