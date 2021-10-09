export default {
    fmtTime(val) {
        const dt = new Date(val);
        //年
        const y = dt.getFullYear();
        //月
        const m = (dt.getMonth() + 1 + '').padStart(2, '0');
        //日
        const d = (dt.getDate() + '').padStart(2, '0');
        //时
        const hh = (dt.getHours() + '').padStart(2, '0');
        //分
        const mm = (dt.getMinutes() + '').padStart(2, '0');
        //秒
        const ss = (dt.getSeconds() + '').padStart(2, '0');

        return `${y}-${m}-${d} ${hh}:${mm}:${ss}`;
    },
    fmtIsContainer(val) {
        return ['是', '否'][val]
    },
}