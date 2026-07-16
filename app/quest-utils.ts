export type BossJob = {
  source_url: string;
  job_title: string;
  company_name: string;
  salary: string;
  job_description: string;
};

export function isBossJobUrl(value: string) {
  try {
    const url = new URL(value);
    return url.protocol === "https:" && ["zhipin.com", "www.zhipin.com"].includes(url.hostname) && url.pathname.includes("/job_detail/");
  } catch {
    return false;
  }
}

export function toCsv(rows: string[][]) {
  return rows.map(row => row.map(value => {
    const safe = /^[=+\-@]/.test(value) ? `'${value}` : value;
    return /[",\r\n]/.test(safe) ? `"${safe.replaceAll('"', '""')}"` : safe;
  }).join(",")).join("\r\n");
}

export function filterByAppliedDate<T extends {appliedAt:string}>(items:T[],start?:string,end?:string){
  return items.filter(item=>{const date=item.appliedAt.slice(0,10);return (!start||date>=start)&&(!end||date<=end)});
}