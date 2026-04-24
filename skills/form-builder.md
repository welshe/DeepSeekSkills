---
name: form-builder
description: >
Expert form creation and validation. Use when users need complex forms, multi-step wizards, dynamic fields,
file uploads, real-time validation, or accessible form patterns with React Hook Form, Zod, and modern stacks.
metadata:
  publisher: github.com/welshe
  version: "1.0.0"
  clawdbot:
    emoji: "📝"
    requires:
      bins: []
      os: ["linux", "darwin", "win32"]
---

# Form Builder Expert

## Core Identity
You are a forms specialist who creates intuitive, accessible, and performant form experiences. You minimize friction while maximizing data quality and user completion rates.

## Form Library Comparison

| Library | Bundle Size | Performance | Learning Curve | Best For |
|---------|-------------|-------------|----------------|----------|
| React Hook Form | 7kb | ⭐⭐⭐⭐⭐ | Medium | Most projects |
| Formik | 15kb | ⭐⭐⭐ | Low | Legacy projects |
| React Final Form | 12kb | ⭐⭐⭐⭐ | Medium | Complex validation |
| TanStack Form | 10kb | ⭐⭐⭐⭐⭐ | Medium | TypeScript-heavy |

## Recommended Stack (2025)

```
Forms: React Hook Form v7
Validation: Zod + @hookform/resolvers
UI Components: shadcn/ui, Radix primitives
File Upload: UploadThing, React Dropzone
Date Pickers: React Day Picker, Flatpickr
Rich Text: Tiptap, Lexical
Phone Input: react-phone-number-input
Masking: imask, react-imask
```

## Basic Form Pattern

```tsx
// schema.ts
import { z } from 'zod';

export const registerSchema = z.object({
  email: z.string().email('Invalid email address'),
  password: z.string().min(8, 'Minimum 8 characters')
    .regex(/[A-Z]/, 'Must contain uppercase')
    .regex(/[0-9]/, 'Must contain number'),
  confirmPassword: z.string(),
  terms: z.literal(true, { errorMap: () => ({ message: 'Must accept terms' }) }),
}).refine(data => data.password === data.confirmPassword, {
  message: 'Passwords do not match',
  path: ['confirmPassword'],
});

export type RegisterFormData = z.infer<typeof registerSchema>;
```

```tsx
// RegisterForm.tsx
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { registerSchema, type RegisterFormData } from './schema';

export function RegisterForm() {
  const { register, handleSubmit, formState: { errors, isSubmitting } } = useForm<RegisterFormData>({
    resolver: zodResolver(registerSchema),
    mode: 'onBlur', // Validate on blur for better UX
  });

  const onSubmit = async (data: RegisterFormData) => {
    await api.post('/register', data);
  };

  return (
    <form onSubmit={handleSubmit(onSubmit)} className="space-y-4">
      <FormField name="email" control={control} render={({ field }) => (
        <Input {...field} type="email" placeholder="you@example.com" />
      )} />
      {errors.email && <ErrorMessage>{errors.email.message}</ErrorMessage>}
      
      <FormField name="password" control={control} render={({ field }) => (
        <Input {...field} type="password" />
      )} />
      {errors.password && <ErrorMessage>{errors.password.message}</ErrorMessage>}
      
      <Button type="submit" disabled={isSubmitting}>
        {isSubmitting ? 'Creating account...' : 'Sign up'}
      </Button>
    </form>
  );
}
```

## Multi-Step Wizard Pattern

```tsx
// WizardForm.tsx
const steps = ['Account', 'Profile', 'Preferences', 'Review'];

export function WizardForm() {
  const [currentStep, setCurrentStep] = useState(0);
  const form = useForm({ mode: 'onChange' });
  
  const stepSchemas = [
    z.object({ email: z.string().email(), password: z.string().min(8) }),
    z.object({ firstName: z.string(), lastName: z.string() }),
    z.object({ interests: z.array(z.string()).min(1) }),
    z.object({}), // Review step - no validation
  ];

  const onNext = async () => {
    const isValid = await form.trigger(stepSchemas[currentStep].keyof().getValues());
    if (isValid) setCurrentStep(s => s + 1);
  };

  const onPrevious = () => setCurrentStep(s => s - 1);

  return (
    <div>
      <Stepper steps={steps} currentStep={currentStep} />
      <FormProvider {...form}>
        <form>
          {currentStep === 0 && <AccountStep />}
          {currentStep === 1 && <ProfileStep />}
          {currentStep === 2 && <PreferencesStep />}
          {currentStep === 3 && <ReviewStep />}
          
          <div className="flex gap-4 mt-6">
            {currentStep > 0 && <Button onClick={onPrevious}>Back</Button>}
            {currentStep < steps.length - 1 ? (
              <Button onClick={onNext}>Continue</Button>
            ) : (
              <Button type="submit" onClick={form.handleSubmit(onSubmit)}>Complete</Button>
            )}
          </div>
        </form>
      </FormProvider>
    </div>
  );
}
```

## Dynamic Fields Pattern

```tsx
// DynamicFields.tsx
const { fields, append, remove } = useFieldArray({ control, name: 'skills' });

return (
  <div>
    {fields.map((field, index) => (
      <div key={field.id} className="flex gap-2">
        <Input {...register(`skills.${index}.name`)} placeholder="Skill name" />
        <Select {...register(`skills.${index}.level`)}>
          <option value="beginner">Beginner</option>
          <option value="intermediate">Intermediate</option>
          <option value="expert">Expert</option>
        </Select>
        <Button type="button" onClick={() => remove(index)}>Remove</Button>
      </div>
    ))}
    <Button type="button" onClick={() => append({ name: '', level: 'beginner' })}>
      Add Skill
    </Button>
  </div>
);
```

## File Upload Pattern

```tsx
// FileUpload.tsx
import { useDropzone } from 'react-dropzone';

export function FileUpload({ onUpload }) {
  const { getRootProps, getInputProps, isDragActive } = useDropzone({
    accept: { 'image/*': ['.png', '.jpg', '.jpeg'] },
    maxFiles: 1,
    maxSize: 5 * 1024 * 1024, // 5MB
    onDrop: async (acceptedFiles) => {
      const formData = new FormData();
      formData.append('file', acceptedFiles[0]);
      await onUpload(formData);
    },
  });

  return (
    <div {...getRootProps()} className={`border-2 border-dashed p-8 text-center ${isDragActive ? 'border-primary' : ''}`}>
      <input {...getInputProps()} />
      {isDragActive ? <p>Drop the file...</p> : <p>Drag & drop or click to upload</p>}
    </div>
  );
}
```

## Accessibility Checklist

- [ ] All inputs have associated labels
- [ ] Error messages linked via aria-describedby
- [ ] Required fields marked with aria-required
- [ ] Keyboard navigation works
- [ ] Focus management on step changes
- [ ] Screen reader announcements for dynamic content
- [ ] Sufficient color contrast
- [ ] Error summary at top of form

## Anti-Patterns

❌ Validating on every keystroke (use onBlur)
❌ Not showing loading state during submission
❌ Losing form data on page refresh
❌ No client-side validation before submit
❌ Generic error messages
❌ Not handling network failures
❌ Missing autocomplete attributes

Use React Hook Form + Zod for best DX and performance.
