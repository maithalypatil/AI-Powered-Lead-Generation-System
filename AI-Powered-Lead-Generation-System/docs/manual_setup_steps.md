# Manual Setup Steps (done in the Salesforce UI)

The metadata in `force-app/` covers fields, validation rule, flow, app and permission set. The items below are configured in Setup because they depend on your org (Einstein, page layouts, users).

---

## 1. Enable Einstein and create the Prompt Template

### 1.1 Turn on Einstein
1. Click the **gear icon → Setup**.
2. In Quick Find search **Einstein Setup** → open it.
3. Switch **Turn on Einstein** to *On*, then refresh the page.

### 1.2 Make sure the field exists
`AI_Summary__c` (Long Text Area, length 32000, 10 visible lines) is deployed by this project. If you built the org by hand: **Object Manager → Lead → Fields & Relationships → New → Long Text Area → Label `AI Summary`**.

### 1.3 Create the template in Prompt Builder
1. Quick Find → **Prompt Builder** → **New Prompt Template**.
2. **Prompt Template Type:** `Field Generation`.
3. **Label:** `AI Summary Field Generation` (API name is filled automatically).
4. **Object:** `Lead`  ·  **Field:** `AI Summary` → **Next**.
5. In the **Prompt** pane, insert these resources (use *Insert Resource → Lead*):

   * Full Name: `{!Lead.Name}`
   * Company: `{!Lead.Company}`
   * Email: `{!Lead.Email}`
   * Phone: `{!Lead.Phone}`
   * Lead Source: `{!Lead.LeadSource}`
   * Lead Status: `{!Lead.Status}`
   * Description: `{!Lead.Description}`

6. Type the sample prompt below under the resources:

```text
Generate a detailed summary of this Lead using the selected fields.
Explain the Lead's background, company information, contact details, status, source, and any key notes clearly.
Summarize relevant details such as the current engagement stage, potential interest level, communication history, and any important remarks.
Provide the summary in a clean, structured, and easy-to-understand format.
```

7. Click **Save**, then **Activate**. The template is ready.

---

## 2. Deploy Prompt Builder on the Lead page (Lightning App Builder)

1. Open the App Launcher (9 dots) → **Leads** → open any lead record.
2. Click the **gear icon → Edit Page**.
3. In the left panel choose **Record Detail** (upgrade to Dynamic Forms if prompted) → **Next** → select the *Lead Layout* → **Finish**.
4. Click the **AI Summary** field on the layout. In the right-hand properties panel enable the Einstein **Field Generation** option and select the template **AI Summary Field Generation**.
5. **Save → Activate** → *Assign as Org Default* → choose **Desktop** (and Phone if needed) → **Next → Save → Back**.

### Test it
1. Open a lead record and click the **AI icon** at the corner of the *AI Summary* field.
2. Review the generated text → click **Use** → click **Save**.
3. The flow `Lead_AI_Summary_Email` fires and sends the e-mail. (If the e-mail is not visible, check *Setup → Email → Deliverability* is set to *All email* and check the spam folder.)

---

## 3. Profiles, Users and Roles

### 3.1 Profiles (Setup → Profiles)
1. Quick Find → **Profiles** → click the profile to change (or **Clone** *Standard User* and name it `Sales Rep - AI Leads`).
2. **Object Settings → Leads:** give Read, Create, Edit (Delete only for managers).
3. **Field-level security:** make Lead Score, Lead Category, Product Interest and AI Summary visible/editable (the permission set already does this).
4. **Tab Settings:** set *Leads* to **Default On**.
5. **Save.**

### 3.2 Roles (Setup → Roles)
Suggested hierarchy:

```
CEO
└── Sales Manager
    └── Sales Representative
```

1. Quick Find → **Roles** → **Add Role** under the parent role.
2. Enter *Role Name / Label* and *This role reports to*. **Save.**
3. Open the role → **Users in this Role → Add** to assign users.

### 3.3 Users (Setup → Users)
1. Quick Find → **Users → New User**.
2. Fill First name, Last name, Alias, Email, Username, Role, User License = *Salesforce*, Profile = `Sales Rep - AI Leads`.
3. **Save.** Then open the user → **Permission Set Assignments → Edit Assignments** → add `AI Lead Gen Access`.
4. To lock a user temporarily use **Freeze**; to remove access uncheck **Active**; to reset a password use **Reset Password**.

---

## 4. Final checklist

- [ ] Metadata deployed without errors
- [ ] Einstein turned on and Prompt Template **AI Summary Field Generation** active
- [ ] Lead record page activated with the AI Summary field generation
- [ ] Sample leads imported; negative-test file rejected
- [ ] Flow e-mail received
- [ ] Screenshots saved in `docs/screenshots/` with labels
- [ ] Demo link and GitHub link added on the SkillWallet project page
