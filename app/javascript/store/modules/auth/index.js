import axios from 'axios'
const state = {
    currentUser: null,
};

const getters = {
    currentUser: state => state.currentUser,
};

const mutations = {
    SET_CURRENT_USER: (state, user) => {
        state.currentUser = user;
        localStorage.setItem('currentUser', JSON.stringify(user))
        axios.defaults.headers.common['Authorization'] = `Bearer ${user.token}`
    },
};

const actions = {
    async login({ commit }, sessionParams) {
        const res = await axios.post(`/api/session`, sessionParams)
        commit("SET_CURRENT_USER", res.data.user);
    },

    logout({ commit }) {
        commit("SET_CURRENT_USER", null);
    },
};

export default {
    namespaced: true,
    state,
    mutations,
    actions,
    getters
};