declare interface TimeReport {
  id: number
  from: Date
  to: Date
  billableHours: number
  project: Project
  document: Document
}
