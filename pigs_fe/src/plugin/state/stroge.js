// export default class LocalStorage {
//
//     static GetCluster(key) {
//         const value = JSON.parse(localStorage.getItem(key))
//         if (value === null || value === undefined || value === '') {
//             return false
//         }
//         return value
//     }
//
// }
export
const GetStorage = () => {
    const cluster = {}
    const cs = JSON.parse(localStorage.getItem("cluster"))
    if (cs !== null && cs !== undefined && cs !== "") {

        cluster.clusterId = cs.clusterId
        cluster.clusterName = cs.clusterName

        return cluster
    }
    return false
}