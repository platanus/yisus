<template>
  <h1>
    Reportes del mes
  </h1>
  <table>
    <thead>
      <tr>
        <th class="px-2">
          Proyecto
        </th>
        <th class="px-2">
          Fecha inicio
        </th>
        <th class="px-2">
          Fecha fin
        </th>
        <th class="px-2">
          Horas facturables
        </th>
        <th class="px-2">
          Acciones
        </th>
      </tr>
    </thead>
    <tbody>
      <tr
        v-for="timeReport in timeReports"
        :key="timeReport.id"
      >
        <td class="px-2">
          {{ timeReport.project.name }}
        </td>
        <td class="px-2">
          {{ timeReport.from }}
        </td>
        <td class="px-2">
          {{ timeReport.to }}
        </td>
        <td class="px-2">
          {{ timeReport.billableHours }}
        </td>
        <td class="px-2">
          <button
            v-if="!timeReport.document"
            @click="createDocument(timeReport.id)"
          >
            Facturar
          </button>
          <a
            v-else
            :href="timeReport.document.url"
            target="_blank"
          >
            Ver factura
          </a>
        </td>
      </tr>
    </tbody>
  </table>
</template>
<script setup lang="ts">
import { useMutation } from 'vue-query';
import documentsApi from '../api/documents';

defineProps<{
  timeReports: TimeReport[]
}>();

function useCreateDocumentMutation() {
  return useMutation((data: { timeReportId: number }) => documentsApi.create(data));
}

const { mutate } = useCreateDocumentMutation();

function createDocument(timeReportId: number) {
  mutate({ timeReportId });
}
</script>
