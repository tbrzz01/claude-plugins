---
name: defect-analysis
description: Perform deep root cause analysis of defects
---

# Defect Deep Dive Analysis

## Description
Performs deep root cause analysis of defects using the 5 Whys technique, identifies issue location, provides mitigations, and creates a resolution plan with tests.

## Input
- JIRA ticket ID or URL
- Free text description of the defect
- Uploaded documents (logs, stack traces, etc.)
- Screenshots showing the issue

## Instructions

You are performing a deep dive analysis of a software defect. Follow this comprehensive methodology:

### Phase 1: Information Gathering

1. **Extract Defect Details**
   - If given a JIRA ticket ID/URL, use the Bash tool with `gh` or `curl` to fetch ticket details (if accessible)
   - Parse the defect description, steps to reproduce, expected vs actual behavior
   - Review any attached documents, logs, or screenshots provided
   - Identify the reported symptoms and user impact

2. **Gather Context**
   - Search for related files mentioned in error messages or stack traces
   - Use Grep to find relevant code paths
   - Check recent git commits that might be related: `git log --all --grep="<keyword>" --since="2 weeks ago"`
   - Look for related issues or similar past defects

### Phase 2: Root Cause Analysis (5 Whys)

Apply the 5 Whys technique to drill down to the root cause:

1. **Why 1**: Why did the defect occur? (Immediate symptom)
   - Document the observable failure
   - Identify the failing component or module

2. **Why 2**: Why did that happen? (Direct cause)
   - Trace the code execution path
   - Identify the specific function/method that failed

3. **Why 3**: Why did that condition exist? (Contributing factors)
   - Examine the logic or state that led to the failure
   - Check for missing validations, edge cases, or assumptions

4. **Why 4**: Why was that allowed to happen? (Systemic issues)
   - Look for missing tests or test coverage gaps
   - Identify design flaws or architectural issues
   - Check for missing error handling or logging

5. **Why 5**: Why did the process allow this? (Process/preventive gaps)
   - Identify gaps in code review, testing strategy, or monitoring
   - Consider why existing safeguards didn't catch this
   - Examine CI/CD pipeline and quality gates

Document each "Why" with:
- The question asked
- Evidence found (file paths, line numbers, code snippets)
- Reasoning and analysis

### Phase 3: Issue Location Analysis

1. **Pinpoint the Defect Location**
   - Identify exact file(s) and line number(s) where the defect exists
   - Use format: `file_path:line_number` for references
   - Provide code snippets showing the problematic code
   - Explain why this code is causing the issue

2. **Impact Assessment**
   - Determine scope: Is this a local issue or does it affect multiple areas?
   - Identify all code paths that might be affected
   - List potentially impacted features or user workflows

3. **Dependency Analysis**
   - Check if the issue is in this codebase or an external dependency
   - Review package versions, API contracts, or service dependencies
   - Identify any version mismatches or breaking changes

### Phase 4: Mitigation Strategies

If the defect is NOT in this codebase or cannot be immediately fixed:

1. **Temporary Workarounds**
   - Suggest configuration changes or feature flags
   - Propose input validation or sanitization
   - Recommend user-facing workarounds or documentation updates

2. **Defensive Coding Measures**
   - Add error handling or graceful degradation
   - Implement circuit breakers or fallback mechanisms
   - Add monitoring/alerting for early detection

3. **Upstream/Downstream Actions**
   - Document external dependencies that need fixing
   - Propose API contract changes or version pinning
   - Suggest communication with external teams

### Phase 5: Resolution Plan

Create a comprehensive fix plan with these sections:

1. **Fix Strategy**
   - Describe the proposed solution approach
   - Explain why this approach addresses the root cause
   - List all files that need to be modified
   - Provide high-level code changes needed

2. **Test Plan**
   - **Unit Tests**: Specific test cases to add/modify
     - Test the fix directly
     - Test edge cases that were missed
     - Include both positive and negative test cases
   - **Integration Tests**: End-to-end scenarios to verify
   - **Regression Tests**: Ensure existing functionality isn't broken
   - **Manual Test Cases**: Steps for QA verification

3. **Validation Criteria**
   - Define success criteria (how to verify the fix works)
   - List metrics or logs to monitor
   - Specify acceptance criteria from user perspective

4. **Rollout Plan**
   - Deployment strategy (feature flag, gradual rollout, etc.)
   - Rollback plan if issues arise
   - Monitoring and alerting setup

5. **Prevention Measures**
   - Code review checklist items
   - New tests or test patterns to adopt
   - Documentation updates needed
   - Process improvements to prevent recurrence

### Phase 6: Summary Report

Generate a structured report with:

```markdown
## Defect Analysis Summary

### Issue Description
[Brief description of the defect]

### 5 Whys Analysis
1. **Why**: [Immediate symptom]
   - Evidence: [file_path:line_number]
   - Analysis: [explanation]

2. **Why**: [Direct cause]
   - Evidence: [file_path:line_number]
   - Analysis: [explanation]

[Continue for all 5 whys]

### Root Cause
[Final root cause identified from Why #5]

### Issue Location
- **Primary Location**: [file_path:line_number]
- **Related Areas**: [list other affected areas]
- **Code Context**:
  ```language
  [problematic code snippet]
  ```

### Impact Assessment
- **Severity**: [Critical/High/Medium/Low]
- **Scope**: [Which features/users affected]
- **Frequency**: [How often this occurs]

### Mitigation (if needed)
[If fix is external or delayed, list temporary mitigations]

### Resolution Plan

#### Proposed Fix
[Detailed description of the solution]

#### Files to Modify
1. `file_path:line_number` - [what changes]
2. `file_path:line_number` - [what changes]

#### Test Strategy
**Unit Tests**:
- [ ] Test case 1: [description]
- [ ] Test case 2: [description]

**Integration Tests**:
- [ ] Scenario 1: [description]

**Regression Tests**:
- [ ] Verify [existing feature] still works

#### Success Criteria
- [ ] Criterion 1
- [ ] Criterion 2

#### Prevention Measures
- [List process/code improvements]

### Next Steps
1. [Action item 1]
2. [Action item 2]
```

## Best Practices

- Always read code before making conclusions
- Use git blame to understand change history: `git blame -L start,end file_path`
- Check test files to understand expected behavior
- Look for TODO/FIXME comments related to the issue
- Search for similar patterns: Use Grep with regex for finding related issues
- Consider performance implications if the defect is performance-related
- Think about edge cases: null values, empty collections, boundary conditions
- Document assumptions clearly

## Tools to Use

- **Read**: Read source files, logs, and documentation
- **Grep**: Search for error messages, function names, patterns
- **Glob**: Find test files, related modules
- **Bash**: Run git commands, check file history, run tests
- **Task**: Launch exploration agents for complex searches
- **WebFetch**: Fetch JIRA tickets or external documentation if accessible

## Example Usage

User: "Analyze defect JIRA-1234 where users are seeing 500 errors on checkout"
User: "Deep dive into this defect: [describes issue with uploaded screenshot]"
User: "Why is the payment processing failing intermittently? Here's the error log: [uploads document]"
