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