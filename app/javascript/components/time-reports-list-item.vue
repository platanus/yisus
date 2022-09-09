<template>
  <tr>
    <td class="px-2">
      {{ timeReport.project.name }}
    </td>
    <td class="px-2">
      {{ timeReport.billableHours }}
    </td>
    <td class="px-2">
      <span v-if="isLoading">
        Cargando...
      </span>
      <span v-else-if="isError">
        Error
      </span>
      <button
        v-else-if="!timeReport.document"
        @click="mutate()"
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
</template>
<script setup lang="ts">
import { useMutation, useQueryClient } from 'vue-query';
import documentsApi from '../api/documents';

const props = defineProps<{
  selectedDate: Date;
  timeReport: TimeReport;
}>();

function useCreateDocumentMutation({ timeReportId, selectedDate }: { timeReportId: number, selectedDate: Date }) {
  const queryClient = useQueryClient();

  return useMutation(() => documentsApi.create({ timeReportId }), {
    onSuccess: () => {
      queryClient.refetchQueries(['timeReports', selectedDate]);
    },
  });
}

const { isLoading, isError, mutate } = useCreateDocumentMutation({
  timeReportId: props.timeReport.id,
  selectedDate: props.selectedDate,
});
</script>
