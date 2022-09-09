<template>
  <div class="flex flex-col space-y-10">
    <h1 class="text-3xl">
      Reportes
    </h1>
    <div class="flex items-center space-x-4">
      <div>
        <button
          class="border py-2 px-3"
          @click="moveMonth(-1)"
        >
          &larr;
        </button>
        <button
          class="border-y border-r py-2 px-3"
          @click="moveMonth(1)"
        >
          &rarr;
        </button>
      </div>
      <div class="text-xl">
        <span class="font-semibold">Mes: </span>{{ currentMonth }}
      </div>
    </div>
    <div
      v-if="isMutationLoading"
      class="w-full rounded bg-gray-300 py-2 px-3 text-center"
    >
      Cargando...
    </div>
    <div
      v-else-if="isMutationError"
      class="w-full rounded bg-gray-300 py-2 px-3 text-center"
    >
      Error
    </div>
    <button
      v-else
      class="rounded bg-gray-300 py-2 px-3 hover:bg-gray-400"
      @click="mutate()"
    >
      Obtener reportes del mes actualizados
    </button>
    <div
      v-if="isQueryLoading"
      class="w-full text-center"
    >
      Cargando...
    </div>
    <div
      v-else-if="isQueryError"
      class="w-full text-center"
    >
      Ha ocurrido un error
    </div>
    <div
      v-else-if="data?.data.timeReports.length === 0"
      class="text-center"
    >
      No hay reportes para este mes
    </div>
    <table v-else>
      <thead class="text-left">
        <tr>
          <th class="px-2">
            Proyecto
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
        <time-reports-list-item
          v-for="timeReport in data?.data.timeReports"
          :key="timeReport.id"
          :time-report="timeReport"
          :selected-date="selectedDate"
        />
      </tbody>
    </table>
  </div>
</template>
<script setup lang="ts">
import { computed, ref, type Ref } from 'vue';
import { useMutation, useQuery } from 'vue-query';
import { addMonths, endOfMonth, format, startOfMonth } from 'date-fns';
import { es } from 'date-fns/locale';
import timeReportsApi from '../api/time-reports';
import timeReportsListItem from './time-reports-list-item.vue';

const selectedDate = ref(new Date());
const currentMonth = computed(() => {
  const startDate = format(startOfMonth(selectedDate.value), 'dd');
  const endDate = format(endOfMonth(selectedDate.value), 'dd MMMM yyyy', { locale: es });

  return `${startDate} - ${endDate}`;
});

function moveMonth(direction: number) {
  selectedDate.value = addMonths(selectedDate.value, direction);
}

function useTimeReportsQuery(date: Ref<Date>) {
  return useQuery(['timeReports', date], () => timeReportsApi.index(date.value.toString()));
}

const { data, isError: isQueryError, isLoading: isQueryLoading, refetch } = useTimeReportsQuery(selectedDate);

function useTimeReportsMutation(date: Ref<Date>) {
  return useMutation(
    () => timeReportsApi.create(date.value.toString()),
    {
      onSuccess: () => {
        refetch.value();
      },
    },
  );
}

const { isError: isMutationError, isLoading: isMutationLoading, mutate } = useTimeReportsMutation(selectedDate);
</script>
