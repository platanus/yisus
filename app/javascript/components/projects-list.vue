<template>
  <table>
    <thead>
      <tr>
        <th class="px-2">
          ID
        </th>
        <th class="px-2">
          Nombre
        </th>
        <th class="px-2">
          Tarifa
        </th>
      </tr>
    </thead>
    <tbody>
      <tr
        v-for="project in projects"
        :key="project.id"
      >
        <td class="px-2">
          {{ project.id }}
        </td>
        <td class="px-2">
          {{ project.name }}
        </td>
        <td class="px-2">
          {{ project.unitPrice }}
        </td>
      </tr>
    </tbody>
  </table>
</template>
<script setup lang="ts">
defineProps<{
  projects: Project[]
}>();
</script>
